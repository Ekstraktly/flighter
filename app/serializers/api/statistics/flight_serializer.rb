module Api
  module Statistics
    class FlightSerializer < ActiveModel::Serializer
      attribute :id
      attribute :revenue
      attribute :no_of_booked_seats
      attribute :occupancy

      def revenue
        object.bookings.map do |booking|
          booking.no_of_seats * booking.seat_price
        end.sum
      end

      def no_of_booked_seats
        object.bookings.sum(:no_of_seats)
      end

      def occupancy
        "#{((no_of_booked_seats.to_d /
             object.no_of_seats.to_d) * 100.0).round(2)}%"
      end
    end
  end
end
