class PaymentMailer < ApplicationMailer

  def request_payment(payment_request_id)
    @payment_request = PaymentRequest.find(payment_request_id)
    headers["X-SMTPAPI"] = MailHeaderService.payment_request_confirmation_headers(@payment_request)
    mail(to: @payment_request.user_email, subject: "Your rental payment request from Roomhere")
  end

  def request_completed(payment_request_id)
    @payment_request = PaymentRequest.find(payment_request_id)
    headers["X-SMTPAPI"] = MailHeaderService.payment_request_completion_headers(@payment_request)
    mail(to: @payment_request.user_email, subject: "Your rent has been paid.")
  end
end
