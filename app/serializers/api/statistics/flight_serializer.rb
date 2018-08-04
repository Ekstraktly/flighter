module Api
  module Statistics
    class FlightSerializer < ActiveModel::Serializer
      attribute :flight_id
      attribute :revenue
      attribute :no_of_booked_seats
      attribute :occupancy

      def revenue
        Booking.joins(:flight)
               .where('cast(flights.id as text) = ?', object.id.to_s)
               .sum('seat_price * bookings.no_of_seats')
      end

      def no_of_booked_seats
        Booking.joins(:flight)
               .where('cast(flights.id as text) = ?', object.id.to_s)
               .sum(:no_of_seats)
      end

      def occupancy
        "#{((no_of_booked_seats.to_d /
             object.no_of_seats.to_d) * 100.0).round(2)}%"
      end

      def flight_id
        object.id
      end
    end
  end
end
