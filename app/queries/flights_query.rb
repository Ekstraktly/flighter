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
    relation.joins(:flight)
            .where('cast(flights.company_id as text) = ?', object.id.to_s)
            .select('SUM(no_of_seats) AS total_no_of_booked_seats')
            .select('SUM(no_of_seats*bookings.no_of_seats) AS total_revenue')
  end
end
