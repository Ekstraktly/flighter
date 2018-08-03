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
      if booking.save
        render json: booking, status: :created
      else
        render json: { errors: booking.errors }, status: :bad_request
      end
    end

    def update
      if booking.update(booking_params
        .merge(user_id: @current_user.id,
               seat_price: calculate_price(booking.flight.base_price,
                                           booking.flight.flys_at)))
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

    def booking
      @booking ||= Booking.find_by id: params[:id]
    end

    def flight
      @flight ||= Flight.find_by id: booking_params[:flight_id]
    end

    def create_booking
      return unless flight
      Booking.new(flight_id: booking_params[:flight_id],
                  user_id: current_user.id,
                  no_of_seats: booking_params[:no_of_seats],
                  seat_price: calculate_price(flight&.base_price,
                                              flight&.flys_at))
    end

    def authorize
      return if booking.user == current_user
      render json: { errors: { resource: ['is forbidden'] } },
             status: :forbidden
    end

    def calculate_price(base_price, flys_at)
      if flys_at <= Time.zone.now
        base_price +
          (((15 - days_to_flight(flys_at)) / 15.0) * base_price)
          .to_i
      else
        base_price * 2
      end
    end

    def days_to_flight(flight_date)
      ((flight_date - Time.zone.now) / (60 * 60 * 24)).to_i
    end
  end
end
