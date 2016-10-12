class RemoveIconsFromAmenities < ActiveRecord::Migration
  def change
    remove_column :amenities, :icon
  end
end
