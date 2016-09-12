class DropOldRolesForRolify < ActiveRecord::Migration
  def change
    drop_table :roles
    drop_table :permissions
  end
end
