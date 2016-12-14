class PaymentRetrievalService

  def initialize(payment_request_token, user)
    @user = user
    @payment_request_token = payment_request_token
  end

  def update!
    payment_request = PaymentRequest.find_by(token: @payment_request_token)
    payment_request.update(user_id: @user.id) if payment_request
  end
end
