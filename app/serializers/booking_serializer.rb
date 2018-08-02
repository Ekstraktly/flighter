class BookingSerializer < ActiveModel::Serializer
  attribute :id
  attribute :flight_id
  attribute :flight_name
  attribute :flys_at
  attribute :lands_at
  attribute :user_id
  attribute :no_of_seats
  attribute :seat_price
  attribute :total_price
  attribute :flight, serializer: FlightSerializer

  belongs_to :user, serializer: UserSerializer

  def total_price
    object.seat_price * object.no_of_seats
  end

  def flight_name
    object.flight.name
  end

  def flys_at
    object.flight.flys_at
  end

  def lands_at
    object.flight.lands_at
  end
end
