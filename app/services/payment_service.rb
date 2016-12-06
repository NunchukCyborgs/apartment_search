class PaymentService

  def initialize(current_user, payment_request, token)
    @current_user = current_user
    @payment_request = payment_request
    @token = token
  end

  def create!
    begin
      Stripe.api_key = ENV["STRIPE_PRIVATE_KEY"]

      payment = Payment.new(user_id: @current_user.id, payment_request_id: @payment_request.id)

      # Create a Customer
      customer = Stripe::Customer.create(
        :source => @token,
        :email => @current_user.email
      )

      charge = Stripe::Charge.create(
        amount: @payment_request.amount_in_cents, # some amount
        currency: "usd",
        customer: customer.id,
        description: @payment_request.description,
        capture: false,
        statement_descriptor: "Roomhere Rent Payment"
      )
      payment.charge_id = charge.id
      @current_user.update(stripe_customer_id: customer.id)
      payment.save

    rescue Stripe::CardError => e
      # Since it's a decline, Stripe::CardError will be caught
      body = e.json_body
      payment.err  = body[:error]
      return payment
    end
  end

end
