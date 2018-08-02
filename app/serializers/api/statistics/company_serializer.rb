module Api
  module Statistics
    class CompanySerializer < ActiveModel::Serializer
      attribute :id
      attribute :total_revenue
      attribute :total_no_of_booked_seats
      attribute :average_price_of_seats

      def total_revenue
        object.flights.map do |flight|
          flight.bookings.map do |booking|
            booking.no_of_seats * booking.seat_price
          end.sum
        end.sum
      end

      def total_no_of_booked_seats
        object.flights.map do |flight|
          flight.bookings.sum(:no_of_seats)
        end.sum
      end

      def average_price_of_seats
        (total_revenue.to_f / total_no_of_booked_seats.to_f).to_f
      end
    end
  end
end
