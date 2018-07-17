class Booking < ActiveRecord::Base
  has_many :users,
  has_many :flights
  validates :seat_price, presence: true,
                         numericality: { greater_than: 0 }
  validates :no_of_seats, presence: true,
                         numericality: { greater_than: 0 }
  validate :past_flight

  def past_flight
    return if Time.zone.parse(:flights.flys_at) > Time.now
  end
end