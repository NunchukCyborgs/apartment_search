# == Schema Information
#
# Table name: contacts
#
#  id               :integer          not null, primary key
#  email            :string(255)
#  phone            :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  contactable_id   :integer
#  contactable_type :string(255)
#
# Indexes
#
#  index_contacts_on_email  (email)
#  index_contacts_on_phone  (phone)
#

require 'test_helper'

class ContactTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
