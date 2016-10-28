class AddApprovedAtToReview < ActiveRecord::Migration
  def change
    add_column :reviews, :approved_at, :datetime
  end
end
