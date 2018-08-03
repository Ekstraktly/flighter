module Api
  module Statistics
    class FlightsController < ApplicationController
      before_action :authentificate, only: [:index]

      def index
        render json: Flight.includes(:bookings),
               each_serializer: Statistics::FlightSerializer
      end
    end
  end
end
