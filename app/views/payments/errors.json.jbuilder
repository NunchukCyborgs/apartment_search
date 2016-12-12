json.errors @errors.respond_to?(:fulle_messages) ? @errors.full_messages : @errors
json.payment_request do
    json.partial! 'payments/payment_request', payment_request: @payment_request if @payment_request
end
