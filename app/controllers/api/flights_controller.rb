module Api
  class FlightsController < ApplicationController
    before_action :authentificate, only: [:index,
                                          :show,
                                          :update,
                                          :destroy,
                                          :create]

    def index
      authorize Flight
      flights = Flight.active.includes(:company)
      if params[:company_id]
        flights = Flight.company_flights(params[:company_id])
                        .includes(:company)
      end
      render json: flights
    end

    def show
      if flight
        authorize flight
        render json: flight
      else
        render json: { errors: current_user.errors }, status: :bad_request
      end
    end

    def create
      authorize Flight
      flight = Flight.new(flight_params)
      if flight.save
        render json: flight, status: :created
      else
        render json: { errors: flight.errors }, status: :bad_request
      end
    end

    def update
      authorize flight
      if flight.update(flight_params)
        render json: flight, status: :ok
      else
        render json: { errors: flight.errors }, status: :bad_request
      end
    end

    def destroy
      authorize flight
      flight.destroy
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
