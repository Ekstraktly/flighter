class UpdateBookingForm < ActiveType::Record[Booking]
  attr_accessor :flight_id, :no_of_seats, :user_id, :id

  validates :no_of_seats, presence: true
  validates :user_id, presence: true

  before_save :set_seat_price

  def save
    # return false unless valid?
    return booking if booking.no_of_seats == no_of_seats
    set_seat_price
    booking.update(no_of_seats: no_of_seats,
                   seat_price: @current_seat_price)
    booking
  end

  private

  def flight
    @flight ||= Flight.find_by(id: booking.flight_id)
  end

  def booking
    @booking ||= Booking.find_by(id: id)
  end

  def set_seat_price
    @current_seat_price = FlightCalculator.new(flight).price
  end
end
