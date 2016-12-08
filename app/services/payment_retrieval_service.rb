class PaymentRetrievalService

  def initialize(payment_request_token, user)
    @user = user
    @payment_request_token = payment_request_token
  end

  def update!
    payment_request = PaymentRequest.find_by(token: @payment_request_token)
    if payment_request
      Stripe.api_key = ENV["STRIPE_PRIVATE_KEY"]

      payment = payment_request.payment
      payment.update(user_id: @user.id)

      charge = Stripe::Charge.retrieve(payment.charge_id)
      customer = Stripe::Customer.retrieve(charge.customer)

      customer.email = @user.email
      customer.save
      @user.update(stripe_customer_id: customer.id)
    end
  end
end
