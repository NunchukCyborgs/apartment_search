class ChangeBathsToFloat < ActiveRecord::Migration
  def change
    change_column :properties, :bathrooms, :float
  end
end
