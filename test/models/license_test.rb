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

require 'test_helper'

class LicenseTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
