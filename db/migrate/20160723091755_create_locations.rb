class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :full_name
      t.string :facet_name
      t.string :data_name
      t.float :latitude
      t.float :longitude

      t.timestamps null: false
    end

    create_table :locations_properties, id: false do |t|
      t.belongs_to :location, index: true
      t.belongs_to :property, index: true
    end

  end
end
