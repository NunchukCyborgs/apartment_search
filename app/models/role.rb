# == Schema Information
#
# Table name: roles
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Role < ActiveRecord::Base

  has_many :permissions
  has_many :users, through: :permissions

  def self.superuser_role
    Role.find_by_name("Superuser")
  end

  def self.landlord_role
    Role.find_by_name("Landlord")
  end

  def self.renter_role
    Role.find_by_name("Renter")
  end
end
