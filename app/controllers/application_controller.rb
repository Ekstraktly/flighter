class ApplicationController < ActionController::Base
  private

  def authentificate
    return if current_user
    render json: { 'errors': { 'token': ['is invalid'] } },
           status: :unauthorized
  end

  def current_user
    @current_user ||= User.find_by(token: request.headers['Authorization'])
  end
end
