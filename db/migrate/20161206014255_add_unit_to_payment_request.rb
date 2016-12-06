class AddUnitToPaymentRequest < ActiveRecord::Migration
  def change
    add_column :payment_requests, :unit, :integer
  end
end
