class ChangeUnitsToString < ActiveRecord::Migration
  def change
    change_column :payment_requests, :unit, :string
  end
end
