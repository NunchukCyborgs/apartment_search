class AddAveragesToProperties < ActiveRecord::Migration
  def change
    add_column :properties, :average_property_rating, :float
    add_column :properties, :average_landlord_rating, :float
  end
end
