class CompaniesQuery
  attr_reader :relation

  def initialize(relation: Company.all)
    @relation = relation
  end

  def with_stats
    relation.left_joins(flights: :bookings)
            .select('COALESCE(SUM(bookings.seat_price * bookings.no_of_seats),0)
                     AS total_revenue')
            .select('COALESCE(SUM(bookings.no_of_seats),0)
                     AS total_no_of_booked_seats')
            .select('COALESCE(SUM(bookings.seat_price * bookings.no_of_seats) /
                     SUM(bookings.no_of_seats),0) AS average_price_of_seat')
            .select('companies.id AS company_id')
            .group(:id)
  end
end
