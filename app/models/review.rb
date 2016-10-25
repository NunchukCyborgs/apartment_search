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
#

class Review < ActiveRecord::Base
  belongs_to :user
  belongs_to :property

  delegate :email, :nickname, to: :user, prefix: true, allow_nil: true

  def anonymous?
    anonymous_at.present?
  end

  def current_tenant?
    current_tenant_at.present?
  end

  def anonymous=(anon)
    self.update(anonymous_at: anon ? DateTime.now : nil)
  end

  def current_tenant=(current)
    self.update(current_tenant_at: current ? DateTime.now : nil)
  end

  def owned?(current_user)
    user_id == current_user.id
  end
end
