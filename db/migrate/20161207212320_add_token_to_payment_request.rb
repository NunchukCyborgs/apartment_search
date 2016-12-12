class AddTokenToPaymentRequest < ActiveRecord::Migration
  def change
    add_column :payment_requests, :token, :string
    add_index :payment_requests, :token
  end
end
