# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      not null
#  created_at             :datetime
#  updated_at             :datetime
#  stripe_customer_id     :string(255)
#  provider               :string(255)      default("email"), not null
#  uid                    :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default("0"), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string(255)
#  failed_attempts        :integer          default("0"), not null
#  unlock_token           :string(255)
#  locked_at              :datetime
#  name                   :string(255)
#  nickname               :string(255)
#  image                  :string(255)
#  tokens                 :text(65535)
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_stripe_customer_id    (stripe_customer_id)
#  index_users_on_uid_and_provider      (uid,provider) UNIQUE
#  index_users_on_unlock_token          (unlock_token) UNIQUE
#

class User < ActiveRecord::Base
  rolify
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable,
          :confirmable
  include DeviseTokenAuth::Concerns::User

  has_one :license
  has_many :properties, through: :license
  has_many :reviews
  has_many :customer_reviews, through: :properties, source: :review
  has_many :contacts
  validates :email, uniqueness: true

  delegate :value, to: :license, prefix: true, allow_nil: true

  def property_cost
    properties.size * Settings.cost_per_property
  end

  def primary_contact
    contacts.first unless contacts.empty?
  end

  def property_count
    properties.size
  end

  def premium?
    stripe_customer_id.present?
  end

  def process_license(license)
    license.update(user_id: id)
  end

  def has_license?
    license.present?
  end

  def superuser?
    return true if has_role?(:superuser)
    return false
  end

  def can_manage_property?(property_id)
    property = Property.friendly.find(property_id) rescue nil
    return false unless property
    return true if superuser?
    return true if current_user.properties.include?(property)
    return false
  end

  def can_manage_contact?(contact_id)
    contact = Contact.friendly.find(contact_id) rescue nil
    contact && contact.user_id == id
  end

  def can_manage_user?(user_id)
    return true if superuser?
    return true if user_id == id
    return false
  end
end
