class PaymentsController < ApplicationController
  skip_authorization_check only: [:create, :request_payment, :index]
  before_action :load_property, only: [:create]
  before_action :create_property_request, only: [:create]

  def create
    @payment = PaymentService.new(current_user, @payment_request, params[:stripeToken]).create!
    if @payment.err.nil?
      render json: { token: @payment_request.token }, status: :ok
    else
      render json: { errors: @payment.errors }, alert: "There was a problem with your subscription. Please try again."
    end
  end

  def fees
    payment_fee_service = PaymentFeeService.new(params[:subtotal])
    render json: { value: payment_fee_service.fees, message: payment_fee_service.message }
  end

  def index
    @payment_requests = current_user.payment_requests
  end

  private

  def create_property_request
    @payment_request = PaymentRequest.new(payment_request_params)
    @payment_request.property = @property
    @payment_request.save
  end

  def load_property
    # wow ugly
    @property = Property.friendly.find(params.require(:payment_request).permit(:property_slug)[:property_slug])
  end

  def payment_request_params
    params.require(:payment_request).permit(:due_on, :name, :subtotal, :unit)
  end

end
