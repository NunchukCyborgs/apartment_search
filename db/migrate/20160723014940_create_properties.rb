class CreateProperties < ActiveRecord::Migration
  def change
    create_table :properties do |t|
      t.string :address1
      t.string :address2
      t.string :zipcode
      t.integer :price
      t.integer :square_footage
      t.string :contact_number
      t.string :contact_email
      t.float :latitude
      t.float :longitude
      t.text :description
      t.date :ranted_at
      t.integer :bedrooms
      t.integer :bathrooms
      t.integer :lease_length
      t.integer :owner_id

      t.timestamps null: false
    end
  end
end
