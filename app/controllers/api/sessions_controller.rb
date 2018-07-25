module Api
  class SessionsController < ApplicationController
    def create
      user_session
      if @user.authenticate(params[:session][:password])
        render json: { session: @session }, status: :created
      else
        render json: {}, status: :unauthorized
      end
    end

    def destroy
      @doomed_session = Session.find_by(token: request.headers['Authorization'])
      @doomed_session.destroy
    end

    private

    def session_params
      params.require(:session).permit(:email, :password)
    end

    def user_session
      if @user ||= User.find_by(email: params[:session][:email])
        @session ||= Session.new(token: @user.token,
                                 user: { id: @user.id,
                                         email: @user.email,
                                         first_name: @user.first_name,
                                         last_name: @user.last_name })
      end
    end
  end
end
