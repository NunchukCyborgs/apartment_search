json.errors @errors.full_messages
json.payment_request do
    json.partial! 'payments/payment_request', payment_request: @payment_request if @payment_request
end
