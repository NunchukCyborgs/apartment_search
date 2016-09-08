# == Schema Information
#
# Table name: permissions
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  role_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class Permission < ActiveRecord::Base
  belongs_to :user
  belongs_to :role
end
