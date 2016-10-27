# == Schema Information
#
# Table name: reviews
#
#  id                :integer          not null, primary key
#  user_id           :integer
#  property_id       :integer
#  body              :text(65535)
#  title             :text(65535)
#  property_rating   :float(24)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  landlord_rating   :float(24)
#  landlord_comments :text(65535)
#  duration          :integer
#  anonymous_at      :datetime
#  current_tenant_at :datetime
#  approved_at       :datetime
#

require 'test_helper'

class ReviewTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
