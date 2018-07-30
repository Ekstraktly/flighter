module Api
  class BookingsController < ApplicationController
    before_action :authentificate, only: [:index,
                                          :show,
                                          :update,
                                          :destroy,
                                          :create]
    before_action :authorize, only: [:update, :destroy, :show]

    def index
      render json: current_user.bookings
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
      if booking.save
        render json: booking, status: :created
      else
        render json: { errors: booking.errors }, status: :bad_request
      end
    end

    def update
      if booking.update(booking_params)
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
                                      :no_of_seats,
                                      :seat_price)
    end

    def booking
      @booking ||= Booking.find_by id: params[:id]
    end

    def create_booking
      Booking.new(flight_id: booking_params[:flight_id],
                  user_id: current_user.id,
                  no_of_seats: booking_params[:no_of_seats],
                  seat_price: booking_params[:seat_price])
    end

    def authorize
      return if booking.user == current_user
      render json: { errors: { resource: ['is forbidden'] } },
             status: :forbidden
    end
  end
end
