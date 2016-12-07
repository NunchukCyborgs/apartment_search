class ChangePaymentRequestDueOnToNumber < ActiveRecord::Migration
  def change
    change_column :payment_requests, :due_on, :integer
  end
end
