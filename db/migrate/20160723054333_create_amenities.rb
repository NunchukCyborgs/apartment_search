class CreateAmenities < ActiveRecord::Migration
  def change
    create_table :amenities do |t|
      t.string :name
      t.string :timestamps

      t.timestamps null: false
    end

    create_table :amenities_properties, id: false do |t|
      t.belongs_to :amenity, index: true
      t.belongs_to :property, index: true
    end
  end
end
