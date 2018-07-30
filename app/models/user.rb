class User < ApplicationRecord
  has_secure_password
  has_secure_token
  has_many :bookings, dependent: :destroy
  has_many :flights, through: :bookings
  validates :email, uniqueness: { case_sensitive: false },
                    presence: true,
                    length: { maximum: 45 },
                    format: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/
  validates :first_name, length: 2..45, presence: true
  validates :last_name, length: { maximum: 45 }
  validates :password_digest, presence: true
end
