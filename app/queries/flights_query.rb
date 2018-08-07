class FlightsQuery
  attr_reader :relation

  def initialize(relation: Flight.all)
    @relation = relation
  end

  def revenue
    relation.sum('seat_price * bookings.no_of_seats')
  end

  def no_of_booked_seats
    relation.sum('bookings.no_of_seats')
  end

  def with_stats
    relation.select('SUM(seat_price * bookings.no_of_seats) AS revenue')
            .select('SUM(bookings.no_of_seats) AS no_of_booked_seats')
            .select('SUM(bookings.no_of_seats) / SUM(no_of_seats)
                     AS occupancy')
  end
end
