# == Schema Information
#
# Table name: scheduled_events
#
#  id         :integer          not null, primary key
#  event      :string(255)
#  name       :string(255)
#  at         :string(255)
#  frequency  :integer
#  tz         :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class ScheduledEventTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
