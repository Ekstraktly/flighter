module Api
  class BookingsController < ApplicationController
    def index
      render json: Booking.select { |booking|
        booking.user_id == @current_user.id
      }
    end

    def show
      booking
      if @booking.user_id == @current_user.id
        render json: @booking
      else
        render json: { 'errors': { 'resource': 'is forbidden' } },
               status: :forbidden
      end
    end

    def create
      user = User.find_by(token: @current_user.token)
      booking = create_booking
      if user && booking.user_id == @current_user.id
        booking.save
        render json: booking, status: :created
      else
        render json: { errors: booking.errors }, status: :unauthorized
      end
    end

    def update
      booking
      if @booking.update(booking_params) &&
         @booking.user_id == @current_user.id
        render json: @booking, status: :ok
      else
        render json: { 'errors': { 'resource': 'is forbidden' } },
               status: :forbidden
      end
    end

    def destroy
      booking
      if @booking.user_id == @current_user.id
        @booking.destroy
      else
        render json: { errors: booking.errors }, status: :unauthorized
      end
    end

    private

    def booking_params
      params.require(:booking).permit(:flight_id,
                                      :user_id,
                                      :no_of_seats,
                                      :seat_price)
    end

    def booking
      @booking ||= Booking.find(params[:id])
    end

    def create_booking
      Booking.new(flight_id: booking_params[:flight_id],
                  user_id: booking_params[:user_id],
                  no_of_seats: booking_params[:no_of_seats],
                  seat_price: booking_params[:seat_price])
    end
  end
end
