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

class User < ActiveRecord::Base
  authenticates_with_sorcery!

  has_many :properties, foreign_key: "owner_id"

  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }

  validates :email, uniqueness: true

  def property_cost
    properties.size * Settings.cost_per_property
  end

  def property_count
    properties.size
  end

  def premium?
    stripe_customer_id.present?
  end
end
