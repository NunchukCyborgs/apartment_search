class PaymentService

  def initialize(current_user, payment_params)
    @current_user = current_user
    @payment_params = payment_params
  end

  def subscribe!
    Stripe.api_key = ENV["STRIPE_PRIVATE_KEY"]

    # Get the credit card details submitted by the form
    token = @payment_params[:stripeToken]

    # Create a Customer
    customer = Stripe::Customer.create(
      :source => token,
      :plan => "property",
      :email => @current_user.email,
      :quantity => @current_user.property_count
    )
    @current_user.update(stripe_customer_id: customer.id)
  end
end
