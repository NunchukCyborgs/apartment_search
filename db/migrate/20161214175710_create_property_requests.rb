class CreatePropertyRequests < ActiveRecord::Migration
  def change
    create_table :property_requests do |t|
      t.string :contact_email
      t.text :address

      t.timestamps null: false
    end
  end
end
