class CreateTypes < ActiveRecord::Migration
  def change
    create_table :types do |t|
      t.string :name

      t.timestamps null: false
    end

    create_table :properties_types, id: false do |t|
      t.belongs_to :type, index: true
      t.belongs_to :property, index: true
    end
  end
end
