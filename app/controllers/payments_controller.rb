class PaymentsController < ApplicationController
  skip_authorization_check only: [:create, :request_payment, :update_request, :fees]
  before_action :load_property, only: [:request_payment]
  before_action :load_property_from_slug, only: [:fees]
  before_action :load_payment_request, only: [:create, :update_request]

  def create
    @payment = PaymentService.new(current_user, @payment_request, params[:stripe_token]).create!
    if @payment.err.nil?
      render 'payments/show', status: :ok
    else
      @errors = @payment.err
      render 'payments/errors', status: :unprocessable_entity
    end
  end

  def fees
    payment_fee_service = PaymentFeeService.new(params[:subtotal])
    render json: { value: payment_fee_service.fees, message: payment_fee_service.message }
  end

  def index
    authorize! :index, Payment
    @payment_requests = current_user.payment_requests
  end

  def request_payment
    @payment_request = PaymentRequest.new(payment_request_params)
    @payment_request.property = @property

    if @payment_request.save
      render 'payments/show', status: :ok
    else
      @errors = @payment_request.errors
      render 'payments/errors', status: :unprocessable_entity
    end
  end

  def update_request
    if @payment_request.payment.nil? && @payment_request.update(payment_request_params)
      render json: { token: @payment_request.token }, status: :ok
    else
      @errors = @payment_request.errors
      render 'payments/errors', status: :unprocessable_entity
    end
  end

  private

  def load_payment_request
    @payment_request = PaymentRequest.find_by(token: params[:token])
  end

  def load_property
    # wow ugly - slightly better
    load_property_from_slug(params[:property_request][:property_slug])
  end

  def load_property_from_slug(slug=nil)
    @property = Property.friendly.find(slug ? slug : params[:property_slug])
  end

  def payment_request_params
    params.require(:payment_request).permit(:due_on, :name, :subtotal, :unit)
  end

end
