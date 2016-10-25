class AddAnonymousAndCurrentToReview < ActiveRecord::Migration
  def change
    add_column :reviews, :anonymous_at, :datetime
    add_column :reviews, :current_tenant_at, :datetime
  end
end
