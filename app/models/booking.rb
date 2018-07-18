class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :flight
  validates :seat_price, presence: true,
                         numericality: { greater_than: 0 }
  validates :no_of_seats, presence: true,
                          numericality: { greater_than: 0 }
  validate :past_flight

  def past_flight
    return if flight && flight.flys_at > Date.current
    errors.add(:flight_id, 'must be booked in the future')
  end
end
