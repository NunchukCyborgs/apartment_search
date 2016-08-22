# == Schema Information
#
# Table name: users
#
#  id               :integer          not null, primary key
#  email            :string(255)      not null
#  created_at       :datetime
#  updated_at       :datetime
#  stripe_customer_id :string(255)

class User < ActiveRecord::Base
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable,
          :confirmable
  include DeviseTokenAuth::Concerns::User

  has_many :properties, foreign_key: "owner_id"

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
