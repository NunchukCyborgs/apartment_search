class AddPermissions < ActiveRecord::Migration
  def change
    create_table :permissions do |t|
      t.integer :user_id
      t.integer :role_id
      t.timestamps
    end
  end
end
