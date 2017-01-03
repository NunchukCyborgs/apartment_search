class PaymentRequestCreatedNotificationJob

  def initialize(payment_request_id)
    @payment_request_id = payment_request_id
  end

  def perform
    SlackNotificationService.new.post("Payment Request ##{@payment_request_id} created. No further action needed.")
  end
end
