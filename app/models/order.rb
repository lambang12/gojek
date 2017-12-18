class Order < ApplicationRecord
  enum status: {
    "Initialized" => "Initialized",
    "Driver Assigned" => "Driver Assigned",
    "Cancelled by System" => "Cancelled by System",
    "Finished" => "Finished"
  }

  enum payment_type: {
    "Cash" => "Cash",
    "Go-Pay" => "Go-Pay",
    "Credit Card" => "Credit Card"
  }

  belongs_to :user
  belongs_to :type
  belongs_to :driver, optional: true

  before_validation :set_base_attributes, :set_calculation_attributes, if: :new_record?

  validates :origin, :destination, :payment_type, presence: true
  validate :destination_must_be_different_than_origin
  validate :locations_must_exist
  validate :distance_cannot_exceed_max_allowed, :distance_matrix_valid
  validate :est_price_cannot_exceed_gopay, if: ->(obj){ obj.payment_type == 'Go-Pay' }
  before_save :capitalize_names

  private
    def capitalize_names
      origin.capitalize!
      destination.capitalize!
    end

    def set_base_attributes
      self.status = "Initialized"
      self.base_fare = type.base_fare unless type.nil?

      origin_coordinates = Gmaps.to_coordinates(origin) unless origin.nil? || origin.empty?
      destination_coordinates = Gmaps.to_coordinates(destination) unless destination.nil? || destination.empty?
      
      unless origin_coordinates.nil? || origin_coordinates.empty?
        self.origin_latitude = origin_coordinates[:lat]
        self.origin_longitude = origin_coordinates[:lng]
      end

      unless destination_coordinates.nil? || destination_coordinates.empty?
        self.destination_latitude = destination_coordinates[:lat]
        self.destination_longitude = destination_coordinates[:lng]
      end
    end

    def destination_must_be_different_than_origin
      if origin == destination
        errors.add(:origin, "must be different with pickup location")
        errors.add(:destination, "must be different with pickup location")
      end
    end

    def locations_must_exist
      if origin_latitude.nil? || origin_longitude.nil?
        errors.add(:origin, "address not found")
      end

      if destination_latitude.nil? || destination_longitude.nil?
        errors.add(:destination, "address not found")
      end
    end

    def set_calculation_attributes
      if geocoder_attributes_exist?
        self.distance = calculate_distance
        self.est_price = distance * base_fare
      end
    end

    def geocoder_attributes_exist?
      !origin_latitude.nil? && !origin_longitude.nil? &&
      !destination_latitude.nil? && !destination_longitude.nil?
    end

    def calculate_distance
      distance = Gmaps.distance_in_km(origin, destination)
      distance = distance.between?(0, 1) ? 1 : distance
    end

    def distance_cannot_exceed_max_allowed
      if !self.distance.nil? && self.distance > RulesService::MAX_DISTANCE_ALLOWED
        errors.add(:destination, "distance cannot exceed 25 km")
      end
    end

    def distance_matrix_valid
      if !self.distance.nil? && self.distance < 0
        errors.add(:base, "Invalid address(s)")
      end
    end

    def est_price_cannot_exceed_gopay
      if self.est_price > user.gopay
        errors.add(:base, "Insufficient amount of Go-Pay")
      end
    end
end
