class PaymentRequestConfirmationJob

  def initialize(payment_request_id)
    @payment_request_id = payment_request_id
  end

  def perform
    PaymentMailer.request_payment(@payment_request_id).deliver!
    SlackNotificationService.new.post("Payment Request ##{@payment_request_id}. Confirmation and Payment Capture needed.")
  end
end
