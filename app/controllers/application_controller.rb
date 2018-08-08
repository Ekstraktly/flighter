class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  rescue_from ActionController::ParameterMissing, with: :parameter_missing

  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response

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
    render json: { errors: { exception.param => ['is missing'] } },
           status: :bad_request
  end

  def render_not_found_response
    render json: { 'errors': { 'resource': ["doesn't exist"] } },
           status: :not_found
  end
end
