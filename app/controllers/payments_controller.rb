class PaymentsController < ApplicationController
  before_action :debug
  before_action :authenticate_user!
  skip_authorization_check only: [:create, :request_payment]

  def create
    payment_request = PaymentRequest.create(payment_request_params)
    @payment = PaymentService.new(current_user, payment_request, params[:stripeToken]).create!
    if @payment.errors.nil?
      render json: { }, status: :ok
    else
      render json: { errors: @payment.errors }, alert: "There was a problem with your subscription. Please try again."
    end
  end

  private

  def payment_request_params
    params.require(:payment_request).permit(:property_id, :due_on, :name, :subtotal, :unit)
  end

end
