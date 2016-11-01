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

  validates :body, presence: true
  validates :title, presence: true
  validates :property_rating, presence: true
  validates :property_id, presence: true
  validates :duration, presence: true

  delegate :email, :nickname, :display_nickname, to: :user, prefix: true, allow_nil: true

  scope :validated, -> { where.not(approved_at: nil) }

  after_save :update_averages

  def anonymous?
    anonymous_at.present?
  end

  def approve!
    update(approved_at: DateTime.now)
  end

  def revoke_approval!
    update(approved_at: nil)
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
    current_user && current_user.id == user_id
  end

  def update_averages
    Delayed::Job.enqueue RatingUpdateJob.new(property_id)
  end

  ### Concessions for a JS front end...
  def is_current_tenant=(current)
    self.current_tenant = current
  end

  def is_anonymous=(anon)
    self.anonymous = anon
  end
end
