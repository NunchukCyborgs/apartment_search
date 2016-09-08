class CreateLicenses < ActiveRecord::Migration
  def change
    create_table :licenses do |t|
      t.string :value
      t.references :user, index: true, foreign_key: true
      t.datetime :claimed_at

      t.timestamps null: false
    end
  end
end
