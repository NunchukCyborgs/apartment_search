class CreateLicenseInstances < ActiveRecord::Migration
  def change
    create_table :license_instances do |t|
      t.references :license, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
