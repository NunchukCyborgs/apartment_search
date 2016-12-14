# == Schema Information
#
# Table name: property_requests
#
#  id            :integer          not null, primary key
#  contact_email :string(255)
#  address       :text(65535)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'rails_helper'

RSpec.describe PropertyRequest, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
