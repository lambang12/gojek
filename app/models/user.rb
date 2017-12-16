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

end
