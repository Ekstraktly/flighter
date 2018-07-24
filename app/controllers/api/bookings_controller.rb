module Api
  class BookingsController < ApplicationController
    def index
      render json: Booking.all
    end

    def show
      booking
      render json: @booking
    end

    def create
      booking = Booking.new(booking_params)
      if booking.save
        render json: booking, status: :created
      else
        render json: { errors: booking.errors }, status: :bad_request
      end
    end

    def update
      booking
      if @booking.update(booking_params)
        render json: @booking, status: :ok
      else
        render json: { errors: @booking.errors }, status: :bad_request
      end
    end

    def destroy
      booking
      @booking.destroy
      head :no_content
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
  end
end
