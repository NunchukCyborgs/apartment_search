# == Schema Information
#
# Table name: contacts
#
#  id         :integer          not null, primary key
#  email      :string(255)
#  phone      :string(255)
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_contacts_on_email    (email)
#  index_contacts_on_phone    (phone)
#  index_contacts_on_user_id  (user_id)
#

class Contact < ActiveRecord::Base
  belongs_to :user
end
