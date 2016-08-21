class AddLicenseIdToProperty < ActiveRecord::Migration
  def change
    add_column :properties, :license_id, :string
    add_index :properties, :license_id
  end
end
