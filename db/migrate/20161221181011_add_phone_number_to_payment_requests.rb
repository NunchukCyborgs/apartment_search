class AddPhoneNumberToPaymentRequests < ActiveRecord::Migration
  def change
    add_column :payment_requests, :phone, :string
  end
end
