module Api
  class SessionsController < ApplicationController
    before_action :authentificate, only: [:destroy]

    def create
      user = User.find_by(email: session_params[:email])
      if user&.authenticate(session_params[:password])
        session = Session.new(user: user, token: user.token)
        render json: session, status: :created
      else
        render json: { 'errors': { 'credentials': ['are invalid'] } },
               status: :bad_request
      end
    end

    def destroy
      current_user.regenerate_token
    end

    private

    def session_params
      params.require(:session).permit(:email, :password)
    end
  end
end
