class AddIconToAmenity < ActiveRecord::Migration
  def change
    add_column :amenities, :icon, :string
  end
end
