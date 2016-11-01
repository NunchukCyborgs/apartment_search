class AddSubtotalToPaymentRequest < ActiveRecord::Migration
  def change
    add_column :payment_requests, :subtotal, :float
  end
end
