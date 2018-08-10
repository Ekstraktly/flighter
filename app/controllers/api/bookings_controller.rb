module Api
  class BookingsController < ApplicationController
    before_action :authentificate, only: [:index,
                                          :show,
                                          :update,
                                          :destroy,
                                          :create]

    def index
      authorize Booking
      bookings = current_user.bookings.joins(:flight)
                             .order('flights.flys_at',
                                    'flights.name',
                                    :created_at)
                             .includes(:flight, :user)
      bookings = bookings.active if params[:filter] == 'active'
      render json: bookings
    end

    def show
      authorize booking
      render json: booking
    end

    def create
      authorize Booking
      form = BookingForm.new(booking_params)
      if form.save
        render json: form, serializer: BookingSerializer, status: :created
      else
        render json: { errors: form.errors }, status: :bad_request
      end
    end

    def update
      authorize booking
      form = ActiveType.cast(booking, BookingForm)
      if form.update(booking_params.merge(flight_id: booking.flight_id))
        render json: form, serializer: BookingSerializer
      else
        render json: { errors: form.errors }, status: :bad_request
      end
    end

    def destroy
      authorize booking
      booking&.destroy
    end

    private

    def booking_params
      params.require(:booking).permit(:flight_id,
                                      :user_id,
                                      :no_of_seats)
            .merge(user_id: current_user.id)
    end

    def booking
      @booking ||= Booking.find(params[:id])
    end
  end
end
