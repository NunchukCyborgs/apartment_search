# == Schema Information
#
# Table name: payment_requests
#
#  id                :integer          not null, primary key
#  user_id           :integer
#  property_id       :integer
#  verified_at       :datetime
#  potential_address :text(65535)
#  due_on            :date
#  name              :string(255)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  subtotal          :float(24)
#  unit              :string(255)
#
# Indexes
#
#  index_payment_requests_on_property_id  (property_id)
#  index_payment_requests_on_user_id      (user_id)
#

require 'test_helper'

class PaymentRequestTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
