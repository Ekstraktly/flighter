module Api
  class BookingsController < ApplicationController
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
      render json: Booking.select { |booking|
        booking.user_id == @current_user.id
      }
    end

    def show
      find_booking
      if @find_booking
        if @find_booking.user_id == @current_user.id
          render json: @find_booking
        else
          render json: { 'errors': { 'resource': ['is forbidden'] } },
                 status: :forbidden
        end
      else
        render json: { errors: @current_user.errors }, status: :bad_request
      end
    end

    def create
      booking = Booking.new(booking_params)
      if booking.user_id == @current_user.id
        if booking.save
          render json: booking, status: :created
        else
          render json: { errors: booking.errors }, status: :bad_request
        end
      else
        render json: { 'errors': { 'resource': ['is forbidden'] } },
               status: :forbidden
      end
    end

    def update
      find_booking
      if @find_booking.user_id == @current_user.id
        if @find_booking.update(booking_params)
          render json: @find_booking, status: :ok
        else
          render json: { errors: find_booking.errors }, status: :bad_request
        end
      else
        render json: { 'errors': { 'resource': ['is forbidden'] } },
               status: :forbidden
      end
    end

    def destroy
      find_booking
      if @find_booking
        if @find_booking.user_id == @current_user.id
          @find_booking.destroy
        else
          render json: { 'errors': { 'resource': ['is forbidden'] } },
                 status: :forbidden
        end
      else
        render json: { errors: @current_user.errors }, status: :bad_request
      end
    end

    private

    def booking_params
      params.require(:booking).permit(:flight_id,
                                      :user_id,
                                      :no_of_seats,
                                      :seat_price)
    end

    def find_booking
      @find_booking ||= Booking.find_by id: params[:id]
    end
  end
end
