# == Schema Information
#
# Table name: licenses
#
#  id            :integer          not null, primary key
#  value         :string(255)
#  user_id       :integer
#  claimed_at    :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  name          :string(255)
#  landlord_name :string(255)
#
# Indexes
#
#  index_licenses_on_user_id  (user_id)
#

class License < ActiveRecord::Base
  belongs_to :user
  has_many :properties

  def claimed?
    claimed_at.present?
  end

  def primary_contact
    user.primary_contact if user
  end
end
