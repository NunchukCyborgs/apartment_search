json.extract! payment_request, :due_on, :subtotal, :total, :unit, :property_slug, :name, :rejected_at, :completed_at, :token, :created_at, :phone
json.payment_submitted_at payment_request.payment.created_at if payment_request.payment
