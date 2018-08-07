module Api
  class UsersController < ApplicationController
    before_action :authentificate, only: [:index, :show, :update, :destroy]
    # before_action :authorize, only: [:update, :destroy, :show]

    def index
      authorize User
      users = User.order(:email).includes(:bookings)
      if params[:query]
        users = users.match_by_query(params[:query])
                     .includes(:bookings)
      end
      render json: users
    end

    def show
      if user
        authorize user
        render json: user
      else
        render json: { 'errors': { 'resource': ['is forbidden'] } },
               status: :forbidden
      end
    end

    def create
      authorize User
      user = User.new(user_params)
      if user.save
        render json: user, status: :created
      else
        render json: { errors: user.errors }, status: :bad_request
      end
    end

    def update
      authorize user
      if user.update(user_params)
        render json: user, status: :ok
      else
        render json: { errors: user.errors }, status: :bad_request
      end
    end

    def destroy
      authorize user
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
      @user ||= User.find(params[:id])
    end
  end
end
