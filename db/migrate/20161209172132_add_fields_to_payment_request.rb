class AddFieldsToPaymentRequest < ActiveRecord::Migration
  def change
    add_column :payment_requests, :rejected_at, :datetime
    add_column :payment_requests, :completed_at, :datetime
  end
end
