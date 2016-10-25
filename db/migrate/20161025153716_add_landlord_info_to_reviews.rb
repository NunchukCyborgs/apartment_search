class AddLandlordInfoToReviews < ActiveRecord::Migration
  def change
    add_column :reviews, :landlord_rating, :float
    add_column :reviews, :landlord_comments, :text
  end
end
