class FlightsQuery
  attr_reader :relation

  def initialize(relation: Flight.all)
    @relation = relation
  end

  def with_stats
    relation.left_joins(:bookings)
            .select('SUM(seat_price * bookings.no_of_seats)
                     AS revenue')
            .select('SUM(bookings.no_of_seats) AS no_of_booked_seats')
            .select('SUM(bookings.no_of_seats)::float / SUM(flights.no_of_seats)
                     AS flight_occupancy')
            .select('flights.id AS flight_id')
            .group(:id)
  end
end
