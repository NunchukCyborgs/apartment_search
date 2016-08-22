# == Schema Information
#
# Table name: users
#
#  id                 :integer          not null, primary key
#  email              :string(255)      not null
#  crypted_password   :string(255)
#  salt               :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  stripe_customer_id :string(255)
#

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
