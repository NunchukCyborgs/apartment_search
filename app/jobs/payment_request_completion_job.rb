class PaymentRequestCompletionJob

  def initialize(payment_request_id)
    @payment_request_id = payment_request_id
  end

  def perform
    PaymentMailer.request_completed(@payment_request_id).deliver!
  end
end
