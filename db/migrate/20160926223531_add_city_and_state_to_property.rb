class AddCityAndStateToProperty < ActiveRecord::Migration
  def change
    add_column :properties, :city, :string
    add_column :properties, :state, :string
  end
end
