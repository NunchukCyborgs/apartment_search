class PaymentCaptureService

  def initialize(payment)
    @payment = payment
  end

  def capture!
    Stripe.api_key = ENV["STRIPE_PRIVATE_KEY"]

    charge = Stripe::Charge.retrieve(@payment.charge_id)
    charge.capture
  end
end
