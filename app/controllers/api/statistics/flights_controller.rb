module Api
  module Statistics
    class FlightsController < ApplicationController
      before_action :authentificate, only: [:index]

      def index
        render json: Flight.all.includes(:bookings),
               each_serializer: Statistics::FlightSerializer
      end
    end
  end
end
