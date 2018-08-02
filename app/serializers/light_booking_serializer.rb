class LightBookingSerializer < ActiveModel::Serializer
  attribute :id
  attribute :flight_id
  attribute :flight_name
  attribute :company_name
  attribute :no_of_seats
  attribute :seat_price

  belongs_to :flight, serializer: FlightSerializer

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

  def company_name
    object.flight.company.name
  end
end
