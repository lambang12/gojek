class Order < ApplicationRecord
  enum status: {
    "Initialized" => "Initialized",
    "Driver Assigned" => "Driver Assigned",
    "Cancelled by System" => "Cancelled by System",
    "Finished" => "Finished"
  }

  enum payment_type: {
    "Cash" => "Cash",
    "Go-Pay" => "Go-Pay"
  }

  belongs_to :user
  belongs_to :type
  belongs_to :driver, optional: true

  before_validation :set_base_attributes, :set_calculation_attributes, if: :new_record?

  validates :origin, :destination, :payment_type, presence: true
  validates_with OrderValidator, if: :new_record?

  before_save :capitalize_names
  after_save :pay_with_gopay, :publish_order, unless: :skip_callbacks

  def self.find_5_minutes_initialized
    orders = Order.where("status = 'Initialized'")
    orders.select { |o| (Time.now - o.created_at) > RulesService::ORDER_TIME_OUT }  
  end

  private
    def set_base_attributes
      self.status = "Initialized"
      self.base_fare = type.base_fare unless type.nil?

      self.origin_coordinates = to_coordinates(origin)
      self.destination_coordinates = to_coordinates(destination)
    end

    def set_calculation_attributes
      if geocoder_attributes_exist?
        self.distance = calculate_distance
        self.est_price = distance * base_fare
      end
    end

    def geocoder_attributes_exist?
      !origin_coordinates.blank? && !destination_coordinates.blank?
    end

    def calculate_distance
      distance = Gmaps.distance_in_km(origin, destination)
      distance = distance.between?(0, 1) ? 1 : distance
    end

    def capitalize_names
      origin.capitalize!
      destination.capitalize!
    end

    def to_coordinates(attr)
      coord = Gmaps.to_coordinates(attr) if !attr.blank?
      coord = !coord.nil? ? coord.join(" ") : nil
    end

    def pay_with_gopay
      if self.payment_type == "Go-Pay"
        begin
          update_gopay
        rescue Errno::ECONNREFUSED => e
          self.update_columns(status: "Cancelled by System", updated_at: Time.now)
        end
      end
    end

    def update_gopay
      if self.status == "Initialized"
        response = GopayService.use(user, self.est_price, self)
      elsif self.status == "Cancelled by System"
        response = GopayService.topup(user, self.est_price, self)
      end

      if !response.nil? && response[:status] == 'OK'
        user.update(gopay: response[:account][:amount])
      elsif !response.nil?
        self.update_columns(status: "Cancelled by System", updated_at: Time.now)
      end
    end

    def publish_order
      if self.status == "Initialized"
        MessagingService.produce_order(self)
      elsif self.status == "Cancelled by System"
        MessagingService.produce_order_cancellation(self)
      end
    end
end
