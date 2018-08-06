class CompaniesQuery
  attr_reader :relation

  def initialize(relation: Company.all)
    @relation = relation
  end

  def total_revenue
    relation.joins(:bookings)
            .sum('seat_price * bookings.no_of_seats')
  end

  def total_no_of_booked_seats
    relation.joins(:bookings)
            .sum('bookings.no_of_seats')
  end

  def with_stats
    relation.joins(:flight)
            .where('cast(flights.company_id as text) = ?', object.id.to_s)
            .select('SUM(no_of_seats) AS total_no_of_booked_seats')
            .select('SUM(no_of_seats*bookings.no_of_seats) AS total_revenue')
  end
end
