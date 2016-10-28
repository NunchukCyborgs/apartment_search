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

class Review < ActiveRecord::Base
  belongs_to :user
  belongs_to :property

  delegate :email, :nickname, :display_nickname, to: :user, prefix: true, allow_nil: true

  after_save :update_averages

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

  def update_averages
    update_landlord_rating
    update_property_rating
    update_combined_rating
  end

  def update_landlord_rating
    ratings = license.properties.map(&:reviews).flatten.map(&:landlord_rating)
    avg = ratings.inject(0.0) { |sum, el| sum + el } / ratings.size
    license.update_attributes!(average_landlord_rating: avg)
  end

  def update_property_rating
    avg = property.reviews.average(:property_rating)
    property.update_attributes!(average_property_rating: avg)
  end

  # used for sorting results, combined weighted averages for property/landlord
  def update_combined_rating
    property_weight, landlord_weight = 1, 1
    weighted_property_rating = property_weight * property.average_property_rating
    weighted_landlord_rating = landlord_weight * license.average_landlord_rating
    combined_avg = (weighted_property_rating + weighted_landlord_rating) / 2
    property.update_attributes!(average_combined_rating: combined_avg)
  end

  def license
    property.license
  end
end
