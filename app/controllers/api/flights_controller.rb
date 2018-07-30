module Api
  class FlightsController < ApplicationController
    before_action :authentificate, only: [:index,
                                          :show,
                                          :update,
                                          :destroy,
                                          :create]
    before_action :current_user, only: [:index,
                                        :show,
                                        :update,
                                        :destroy,
                                        :create]

    def index
      render json: Flight.all
    end

    def show
      flight
      if @flight
        render json: @flight
      else
        render json: { errors: @current_user.errors }, status: :bad_request
      end
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
      if @flight
        @flight.destroy
      else
        render json: { errors: @current_user.errors }, status: :bad_request
      end
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
      @flight ||= Flight.find_by id: params[:id]
    end
  end
end
