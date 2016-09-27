class AddAvailableAtToProperty < ActiveRecord::Migration
  def change
    add_column :properties, :available_at, :datetime
  end
end
