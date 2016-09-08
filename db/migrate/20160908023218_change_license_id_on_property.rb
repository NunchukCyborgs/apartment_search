class ChangeLicenseIdOnProperty < ActiveRecord::Migration
  def change
    remove_column :properties, :license_id
    add_reference :properties, :license, index: true, foreign_key: true
    remove_column :properties, :owner_id
  end
end
