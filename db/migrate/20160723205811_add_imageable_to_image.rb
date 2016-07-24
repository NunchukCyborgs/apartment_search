class AddImageableToImage < ActiveRecord::Migration
  def change
    add_reference :images, :imageable, polymorphic: true, index: true
  end
end
