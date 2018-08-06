module Api
  module Statistics
    class CompanySerializer < ActiveModel::Serializer
      attribute :company_id
      attribute :total_revenue
      attribute :total_no_of_booked_seats
      attribute :average_price_of_seats

      def total_revenue
        CompaniesQuery.new(relation: object.flights)
                      .total_revenue
      end

      def total_no_of_booked_seats
        CompaniesQuery.new(relation: object.flights)
                      .total_no_of_booked_seats
      end

      def average_price_of_seats
        return 0 if total_no_of_booked_seats.zero?
        (total_revenue.to_f / total_no_of_booked_seats.to_f).to_f
      end

      def company_id
        object.id
      end
    end
  end
end
