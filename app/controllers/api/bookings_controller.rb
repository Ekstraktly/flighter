module Api
  class BookingsController < ApplicationController
    before_action :authentificate, only: [:index,
                                          :show,
                                          :update,
                                          :destroy,
                                          :create]
    before_action :authorize, only: [:update, :destroy, :show]

    def index
      render json:
        if params[:filter] == 'active'
          current_user.bookings.active
        else
          current_user.bookings.joins(:flight)
            .order('flights.flys_at',
                   'flights.name',
                   :created_at)
                      .includes(:flight, :user)
        end
    end

    def show
      if booking
        render json: booking
      else
        render json: { 'errors': { 'resource': ['is forbidden'] } },
               status: :forbidden
      end
    end

    def create
      booking = create_booking
      if booking&.save
        render json: booking, status: :created
      else
        render json: { errors: booking.errors }, status: :bad_request
      end
    end

    def update
      if booking.update(params_for_update)
        render json: booking
      else
        render json: { errors: booking.errors }, status: :bad_request
      end
    end

    def destroy
      booking&.destroy
    end

    private

    def booking_params
      params.require(:booking).permit(:flight_id,
                                      :user_id,
                                      :no_of_seats)
    end

    def params_for_update
      booking_params
        .merge(user_id: @current_user.id,
               seat_price: booking.flight&.calculate_price)
    end

    def booking
      @booking ||= Booking.find(params[:id])
    end

    def flight
      @flight ||= Flight.find_by(id: booking_params[:flight_id])
    end

    def create_booking
      Booking.new(flight_id: booking_params[:flight_id],
                  user_id: current_user.id,
                  no_of_seats: booking_params[:no_of_seats],
                  seat_price: flight&.calculate_price)
    end

    def authorize
      return if booking.user == current_user
      render json: { errors: { resource: ['is forbidden'] } },
             status: :forbidden
    end
  end
end
