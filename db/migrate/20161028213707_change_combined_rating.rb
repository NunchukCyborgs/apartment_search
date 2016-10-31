class ChangeCombinedRating < ActiveRecord::Migration
  def change
    rename_column :properties, :combined_rating, :average_combined_rating
  end
end
