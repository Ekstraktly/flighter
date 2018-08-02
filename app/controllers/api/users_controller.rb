module Api
  class UsersController < ApplicationController
    before_action :authentificate, only: [:index, :show, :update, :destroy]
    before_action :authorize, only: [:update, :destroy, :show]

    def index
      render json:
        if params[:first_name] || params[:last_name] || params[:email]
          find_user(params)
        else
          User.all.order(:email).includes(:bookings)
        end
    end

    def show
      if user
        render json: user
      else
        render json: { 'errors': { 'resource': ['is forbidden'] } },
               status: :forbidden
      end
    end

    def create
      user = User.new(user_params)
      if user.save
        render json: user, status: :created
      else
        render json: { errors: user.errors }, status: :bad_request
      end
    end

    def update
      if user.update(user_params)
        render json: user, status: :ok
      else
        render json: { errors: user.errors }, status: :bad_request
      end
    end

    def destroy
      user&.destroy
    end

    private

    def user_params
      params.require(:user).permit(:email,
                                   :first_name,
                                   :last_name,
                                   :password)
    end

    def user
      @user ||= User.find_by id: params[:id]
    end

    def authorize
      return if user == current_user
      render json: { errors: { resource: ['is forbidden'] } },
             status: :forbidden
    end

    def find_user(params)
      User.all.where('lower(first_name) = ? OR lower(last_name) = ? OR
                      lower(email) = ?',
                     params[:first_name].to_s.downcase,
                     params[:last_name].to_s.downcase,
                     params[:email].to_s.downcase)
          .order(:email)
          .includes(:bookings)
    end
  end
end
