class ChangeRantedAtToRentedAt < ActiveRecord::Migration
  def change
    remove_column :properties, :ranted_at
    add_column :properties, :rented_at, :date
  end
end
