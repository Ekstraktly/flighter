module Api
  class UsersController < ApplicationController
    def index
      render json: User.select { |user|
        user.id == @current_user.id
      }
    end

    def show
      user
      if @user.id == @current_user.id
        render json: @user
      else
        render json: { 'errors': { 'resource': 'is forbidden' } },
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
      user
      if @user.update(user_params) && @user.id == @current_user.id
        render json: @user, status: :ok
      else
        render json: { 'errors': { 'resource': 'is forbidden' } },
               status: :forbidden
      end
    end

    def destroy
      user
      if @user.id == @current_user.id
        @user.destroy
      else
        render json: { errors: user.errors }, status: :unauthorized
      end
    end

    private

    def user_params
      params.require(:user).permit(:email,
                                   :first_name,
                                   :last_name,
                                   :password_digest)
    end

    def user
      @user ||= User.find(params[:id])
    end
  end
end
