# == Schema Information
#
# Table name: reviews
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  property_id :integer
#  body        :text(65535)
#  title       :text(65535)
#  rating      :float(24)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Review < ActiveRecord::Base
  belongs_to :user
  belongs_to :property

  delegate :email, to: :user, prefix: true, allow_nil: true
end
