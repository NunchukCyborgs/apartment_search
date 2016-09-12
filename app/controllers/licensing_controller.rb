class LicensingController < ApplicationController

  def authenticate
    status_404 and return unless params[:license_id]
    license = License.find_by(value: params[:license_id])
    status_404 and return if license.nil? || license.claimed?
    current_user.process_license license
  end

  private

  def status_404
    render json: { result: "failed" }, status: 404
  end

end
