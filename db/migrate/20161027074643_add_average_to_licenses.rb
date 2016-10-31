class AddAverageToLicenses < ActiveRecord::Migration
  def change
    add_column :licenses, :average_landlord_rating, :float
  end
end
