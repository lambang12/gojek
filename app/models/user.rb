class User < ApplicationRecord
  has_secure_password
  has_many :orders

  validates :email, :first_name, :last_name, :phone, presence: true
  validates :email, uniqueness: { case_sensitive: false }, format: {
    with: /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i,
    message: 'format is invalid'
  }
  validates :phone, uniqueness: true, length: { maximum: 12 }, numericality: true
  validates :password, presence: true, on: :create
  validates :password, length: { minimum: 8 }, allow_blank: true
  validates :gopay, numericality: { greater_than_or_equal_to: 0 }
  validate :check_in_other_service, unless: :skip_callbacks

  before_save :capitalize_names

  after_create :register_gopay, unless: :skip_callbacks

  private
    def capitalize_names
      first_name.capitalize!
      last_name.capitalize!
    end

    def check_in_other_service
      response = DriverApi.send_check_request(self)
      if response[:user_exists]
        errors.add(:base, "This user has been registered to other service")
      end
    end

    def register_gopay
      GopayService.register_gopay(self)
    end
end
