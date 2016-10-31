class FixRatings < ActiveRecord::Migration
  def change
    remove_column :properties, :average_landlord_rating
    add_column :properties, :combined_rating, :float
  end
end
