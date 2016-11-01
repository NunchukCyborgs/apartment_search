class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.references :user, index: true, foreign_key: true
      t.references :payment_request, index: true, foreign_key: true
      t.string :charge_id
      t.datetime :captured_at

      t.timestamps null: false
    end
  end
end
