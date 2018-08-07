class BookingForm < ActiveType::Record[Booking]
  attr_accessor :flight_id, :no_of_seats, :user_id, :id

  validates :flight_id, presence: true
  validates :no_of_seats, presence: true
  validates :user_id, presence: true

  before_save :set_seat_price

  def save
    # return false unless valid?
    set_seat_price
    Booking.create(flight_id: flight_id,
                   user_id: user_id,
                   no_of_seats: no_of_seats,
                   seat_price: @current_seat_price)
  end

  def update
    # return false unless valid?
    return booking unless booking.no_of_seats_changed?
    set_seat_price
    if booking.update(no_of_seats: no_of_seats,
                      seat_price: @current_seat_price)
      booking
    else
      false
    end
  end

  def flight
    @flight ||= Flight.find_by(id: flight_id)
  end

  def booking
    @booking ||= Booking.find_by(id: id)
  end

  def set_seat_price
    @current_seat_price = FlightCalculator.new(flight).price
  end
end
