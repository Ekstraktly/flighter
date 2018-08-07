module Api
  module Statistics
    class FlightsController < ApplicationController
      before_action :authentificate, only: [:index]

      def index
        render json: flights_with_stats,
               each_serializer: Statistics::FlightSerializer
      end

      def flights_with_stats
        FlightsQuery.new(relation: Flight.all)
                    .with_stats
                    .includes(:bookings)
      end
    end
  end
end
