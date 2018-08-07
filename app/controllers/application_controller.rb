class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  rescue_from ActionController::ParameterMissing, with: :parameter_missing

  private

  def authentificate
    return if current_user
    render json: { 'errors': { 'token': ['is invalid'] } },
           status: :unauthorized
  end

  def current_user
    @current_user ||= User.find_by(token: request.headers['Authorization'])
  end

  def user_not_authorized
    render json: { 'errors': { 'resource': ['is forbidden'] } },
           status: :forbidden
  end

  def parameter_missing(exception)
    render json: { errors: exception.record.errors }, status: :bad_request
  end
end
