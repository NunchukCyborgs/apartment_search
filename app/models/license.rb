# == Schema Information
#
# Table name: licenses
#
#  id                      :integer          not null, primary key
#  value                   :string(255)
#  user_id                 :integer
#  claimed_at              :datetime
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  name                    :string(255)
#  landlord_name           :string(255)
#  average_landlord_rating :float(24)
#
# Indexes
#
#  index_licenses_on_user_id  (user_id)
#

class License < ActiveRecord::Base
  has_many :license_instances
  has_many :users, through: :license_instancess
  has_many :properties
  has_many :reviews, through: :properties
  has_many :contacts, as: :contactable

  def claimed?
    license_instances.verified.size > 0
  end

  def primary_contact
    contacts.first || Contact.new
  end
end
