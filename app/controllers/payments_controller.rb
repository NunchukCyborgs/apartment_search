class PaymentsController < ApplicationController
  before_action :authenticate_user!

  def create
    payment_request = PaymentRequest.find(params[:payment_request_id])
    @payment = PaymentService.new(current_user, payment_request, params[:stripeToken]).create!
    unless @payment.errors
      render json: { }, status: :ok
    else
      render json: { errors:  }, alert: "There was a problem with your subscription. Please try again."
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
