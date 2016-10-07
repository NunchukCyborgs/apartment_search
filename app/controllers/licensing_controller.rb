class LicensingController < ApplicationController
  skip_authorization_check only: [:show]

  def show
    status_404 and return unless current_user.has_role? :superuser
    @license = License.find_by(value: params[:license_id])
    status_404 and return unless @license
  end

  def authenticate
    status_404 and return unless params[:license_id] && current_user.can? :authenticate, License
    license = License.find_by(value: params[:license_id])
    status_404 and return if license.nil? || license.claimed?
    status_unprocessable and return if current_user.has_license?
    current_user.process_license license
    render json: { license_id: license.id }, status: ok
  end

  private

  def status_404
    render json: { result: "failed" }, status: 404
  end

  def status_unprocessable
    render json: { result: "failed" }, status: :unprocessable_entity
  end

end
