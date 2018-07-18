class Booking < ApplicationRecord
  belongs_to :users
  belongs_to :flights
  validates :seat_price, presence: true,
                         numericality: { greater_than: 0 }
  validates :no_of_seats, presence: true,
                          numericality: { greater_than: 0 }
  # validate :past_flight

  # def past_flight
  #  return if flys_at > Date.current
  # end
end
