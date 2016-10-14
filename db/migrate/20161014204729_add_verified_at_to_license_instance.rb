class AddVerifiedAtToLicenseInstance < ActiveRecord::Migration
  def change
    add_column :license_instances, :verified_at, :datetime
    add_index :license_instances, :verified_at
  end
end
