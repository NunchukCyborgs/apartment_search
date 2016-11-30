class AddUnitsToProperty < ActiveRecord::Migration
  def change
    add_column :properties, :units, :integer
  end
end
