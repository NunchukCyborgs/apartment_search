class AddLandlordNamesToLicense < ActiveRecord::Migration
  def change
    add_column :licenses, :name, :string
    add_column :licenses, :landlord_name, :string
  end
end
