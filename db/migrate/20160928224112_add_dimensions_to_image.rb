class AddDimensionsToImage < ActiveRecord::Migration
  def change
    add_column :images, :height, :string
    add_column :images, :width, :string
  end
end
