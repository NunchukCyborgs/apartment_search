class ApplicationController < ActionController::Base
  include DeviseTokenAuth::Concerns::SetUserByToken
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  skip_before_filter :verify_authenticity_token

  check_authorization

  rescue_from ActiveRecord::RecordNotFound, with: :render_404
  rescue_from CanCan::AccessDenied, with: :render_403

  def current_ability
    @current_ability ||= Ability.new(current_user, params)
  end

  private

  def render_403
    render json: {}, status: 403
  end

  def render_404
    render json: {}, status: 404
  end

end
