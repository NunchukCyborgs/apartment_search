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

class PropertyRequest < ActiveRecord::Base

  after_create :send_notification

  private
  def send_notification
    Delayed::Job.enqueue PropertyRequestJob.new(self.id)
  end
end
