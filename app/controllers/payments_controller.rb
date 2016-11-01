class PaymentsController < ApplicationController
  before_action :authenticate_user!

  def create
    if PaymentService.new(current_user, params).subscribe!
      redirect_to :back
    else
      redirect_to :back, alert: "There was a problem with your subscription. Please try again."
    end
  end

  def request
    @payment_request = PaymentRequest.new(payment_request_params)
    if @payment_request.save
      render json: { id: @payment_request.id }, status: :ok
    else
      render json: { errors: @payment_request.errors }, status: :unprocessable_entity
    end
  end

  private

  def payment_request_params
    params.require(:payment_request).permit(:id, :property_id, :potential_address, :due_on, :name, :subtotal, contact_attributes: [ :id, :phone, :email, :_destroy ])
end
