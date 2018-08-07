module Api
  module Statistics
    class FlightSerializer < ActiveModel::Serializer
      attribute :flight_id
      attribute :revenue
      attribute :no_of_booked_seats
      attribute :occupancy

      def occupancy
        return 0 if object.flight_occupancy.nil?
        "#{(object.flight_occupancy * 100.0).round(2)}%"
      end
    end
  end
end
