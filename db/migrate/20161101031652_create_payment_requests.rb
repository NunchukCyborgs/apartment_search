class CreatePaymentRequests < ActiveRecord::Migration
  def change
    create_table :payment_requests do |t|
      t.references :user, index: true, foreign_key: true
      t.references :property, index: true, foreign_key: true
      t.datetime :verified_at
      t.text :potential_address
      t.date :due_on
      t.string :name

      t.timestamps null: false
    end
  end
end
