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
