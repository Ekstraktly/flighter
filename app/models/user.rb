class User < ActiveRecord::Base
  has_many :bookings
  validates :email, uniqueness: { case_sensitive: false },
                    presence: true,
                    length: { maximum: 45 },
                    format: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/
  validates :first_name, length: 2..45, presence: true
  validates :last_name, length: { maximum: 45 }

end