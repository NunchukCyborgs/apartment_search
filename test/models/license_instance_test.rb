# == Schema Information
#
# Table name: license_instances
#
#  id          :integer          not null, primary key
#  license_id  :integer
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  verified_at :datetime
#
# Indexes
#
#  index_license_instances_on_license_id   (license_id)
#  index_license_instances_on_user_id      (user_id)
#  index_license_instances_on_verified_at  (verified_at)
#

require 'test_helper'

class LicenseInstanceTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
