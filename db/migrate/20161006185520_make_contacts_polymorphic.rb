class MakeContactsPolymorphic < ActiveRecord::Migration
  def change
    change_table :contacts do |t|
      t.references :contactable, polymorphic: true
    end
    remove_reference :contacts, :user, index: true
  end
end
