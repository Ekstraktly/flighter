module Api
  class FlightsController < ApplicationController
    def index
      render json: Flight.all
    end

    def show
      flight
      render json: @flight
    end

    def create
      flight = Flight.new(flight_params)
      if flight.save
        render json: flight, status: :created
      else
        render json: { errors: flight.errors }, status: :bad_request
      end
    end

    def update
      flight
      if @flight.update(flight_params)
        render json: @flight, status: :ok
      else
        render json: { errors: @flight.errors }, status: :bad_request
      end
    end

    def destroy
      flight
      @flight.destroy
      head :no_content
    end

    private

    def flight_params
      params.require(:flight).permit(:company_id,
                                     :name,
                                     :no_of_seats,
                                     :base_price,
                                     :flys_at,
                                     :lands_at)
    end

    def flight
      @flight ||= Flight.find(params[:id])
    end
  end
end
