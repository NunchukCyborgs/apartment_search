class RenameRatingOnReview < ActiveRecord::Migration
  def change
    rename_column :reviews, :rating, :property_rating
  end
end
