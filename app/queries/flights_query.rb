class FlightsQuery
  attr_reader :relation

  def initialize(relation: Flight.all)
    @relation = relation
  end

  def with_stats
    relation.left_joins(:bookings)
            .select('COALESCE(SUM(seat_price * bookings.no_of_seats),0)
                     AS revenue')
            .select('COALESCE(SUM(bookings.no_of_seats),0)
                     AS no_of_booked_seats')
            .select('COALESCE(SUM(bookings.no_of_seats)::float /
                     SUM(flights.no_of_seats),0)
                     AS flight_occupancy')
            .select('flights.id AS flight_id')
            .group(:id)
  end
end
