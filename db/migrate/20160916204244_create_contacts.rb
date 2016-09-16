class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :email
      t.string :phone
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
    add_index :contacts, :email
    add_index :contacts, :phone
  end
end
