# == Schema Information
#
# Table name: payments
#
#  id                 :integer          not null, primary key
#  user_id            :integer
#  payment_request_id :integer
#  charge_id          :string(255)
#  captured_at        :datetime
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_payments_on_payment_request_id  (payment_request_id)
#  index_payments_on_user_id             (user_id)
#

require 'test_helper'

class PaymentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
