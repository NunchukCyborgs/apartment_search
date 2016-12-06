class PaymentsController < ApplicationController
  before_action :authenticate_user!
  skip_authorization_check only: [:create, :request_payment]

  def create
    payment_request = PaymentRequest.create(payment_request_params)
    @payment = PaymentService.new(current_user, payment_request, params[:stripeToken]).create!
    if @payment.err.nil?
      render json: { }, status: :ok
    else
      render json: { errors: @payment.errors }, alert: "There was a problem with your subscription. Please try again."
    end
  end

  def fees
    payment_fee_service = PaymentFeeService.new(params[:subtotal])
    render json: { value: payment_fee_service.fees, message: payment_fee_service.message }
  end

  private

  def payment_request_params
    params.require(:payment_request).permit(:property_id, :due_on, :name, :subtotal, :unit)
  end

end
