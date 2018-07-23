module Api
  class BookingsController < ApplicationController
    def index
      render json: Booking.all, each_serializer: BookingSerializer
    end

    def show
      booking = Booking.find(params[:id])
      render json: booking, serializer: BookingSerializer
    end

    def create
      booking = Booking.new(booking_params)
      if booking.save
        render json: booking, status: :created
      else
        render json: booking.errors, status: :bad_request
      end
    end

    def update
      @booking = Booking.find(params[:id])
      if @booking.update(booking_params)
        render json: @booking, status: :ok
      else
        render json: @booking.errors, status: :bad_request
      end
    end

    def destroy
      @booking = Booking.find(params[:id])
      if @booking.destroy
        render json: @booking, status: :no_content
      else
        render json: @booking.errors, status: :bad_request
      end
    end

    private

    def booking_params
      params.require(:booking).permit(:flight_id,
                                      :user_id,
                                      :no_of_seats,
                                      :seat_price)
    end
  end
end
