class AddDurationToReview < ActiveRecord::Migration
  def change
    add_column :reviews, :duration, :integer
  end
end
