class Flight < ApplicationRecord
  belongs_to :company
  has_many :bookings
  has_many :users, through: :bookings

  validates :name, length: { maximum: 45 },
                   presence: true,
                   uniqueness: { case_sensitive: false }
  validates :no_of_seats, numericality: { only_integer: true }
  validates :base_price, numericality: { greater_than: 0 },
                         presence: true
  # validate :flys_before_lands

  # private

  # def flys_before_lands
  #  return if flys_at < lands_at
  #  errors.add(:land_at, 'must be later than flys_at')
  # end
end
