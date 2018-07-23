module Api
  class UsersController < ApplicationController
    def index
      render json: User.all, each_serializer: UserSerializer
    end

    def show
      user = User.find(params[:id])
      render json: user, serializer: UserSerializer
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
      @user = User.find(params[:id])
      if @user.update(user_params)
        render json: @user, status: :ok
      else
        render json: { errors: @user.errors }, status: :bad_request
      end
    end

    def destroy
      @user = User.find(params[:id])
      if @user.destroy
        render json: @user, status: :no_content
      else
        render json: @user.errors, status: :bad_request
      end
    end

    private

    def user_params
      params.require(:user).permit(:email, :first_name, :last_name)
    end
  end
end
