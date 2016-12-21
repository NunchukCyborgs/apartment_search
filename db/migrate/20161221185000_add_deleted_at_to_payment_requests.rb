class AddDeletedAtToPaymentRequests < ActiveRecord::Migration
  def change
    add_column :payment_requests, :deleted_at, :datetime
    add_index :payment_requests, :deleted_at
  end
end
