class ApplicationController < ActionController::Base
  before_action :verify_authenticity_token, only: [:index,
                                                   :show,
                                                   :update,
                                                   :create,
                                                   :destroy]

  private

  def authentificate
    return if User.find_by(token: request.headers['Authorization'])
    render json: { 'errors': { 'token': ['is invalid'] } }, status: :unauthorized
  end

  def current_user
    @current_user ||= User.find_by(token: request.headers['Authorization'])
  end
end
