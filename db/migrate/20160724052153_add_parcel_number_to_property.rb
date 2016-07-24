class AddParcelNumberToProperty < ActiveRecord::Migration
  def change
    add_column :properties, :parcel_number, :string
    add_index :properties, :parcel_number
  end
end
