class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :flight
  validates :seat_price, presence: true,
                         numericality: { greater_than: 0 }
  validates :no_of_seats, presence: true,
                          numericality: { greater_than: 0 }
  validate :past_flight
  validate :overbooked

  scope :active, lambda {
    joins(:flight)
      .where('flys_at > ?', Time.zone.now)
      .all
      .order('flights.flys_at',
             'flights.name',
             :created_at)
      .includes(:flight, :user)
  }

  def past_flight
    return if flight && flight.flys_at > Time.current
    errors.add(:flight, 'must be booked in the future')
  end

  def overbooked
    return if flight &&
              (total_booked_seats_on_flight <= flight.no_of_seats)
    errors.add(:no_of_seats, 'not enough seats on this flight')
  end

  def total_booked_seats_on_flight
    no_of_seats.to_i + Booking.where.not(user_id: user.id)
                       .where(flight_id: flight.id)
                              .sum(:no_of_seats)
  end
end
