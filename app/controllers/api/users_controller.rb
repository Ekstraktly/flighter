module Api
  class UsersController < ApplicationController
    def index
      render json: User.all
    end

    def show
      user
      render json: @user
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
      if @user.update(user_params)
        render json: @user, status: :ok
      else
        render json: { errors: @user.errors }, status: :bad_request
      end
    end

    def destroy
      user
      @user.destroy
      head :no_content
    end

    private

    def user_params
      params.require(:user).permit(:email, :first_name, :last_name)
    end

    def user
      @user ||= User.find(params[:id])
    end
  end
end
