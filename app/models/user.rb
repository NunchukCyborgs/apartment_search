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
#  verified_at            :datetime
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

  has_many :license_instances
  has_many :licenses, through: :license_instances
  has_many :properties, through: :licenses
  has_many :payment_requests
  has_many :payments, through: :payment_requests
  has_many :reviews
  has_many :customer_reviews, through: :properties, source: :review
  has_many :contacts, as: :contactable
  validates :email, uniqueness: true

  after_create :notify_creation

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
    return false if licenses.include?(license)
    i = LicenseInstance.create(user_id: id, license_id: license.id)
    Delayed::Job.enqueue UserLicensedNotificationJob.new(id, license.id)
    i
  end

  def has_license?
    licenses.size > 0
  end

  def superuser?
    has_role?(:superuser)
  end

  def can_manage_property?(property_id)
    property = Property.includes(:license).friendly.find(property_id) rescue nil
    return false unless property
    license = property.license
    license_instance = license_instances.find_by(license_id: license.id)
    return true if superuser?
    return true if owns_property?(property.id) && license_instance.verified_at
    return false
  end

  def owns_property?(property_id)
    properties.find(property_id) rescue nil
  end

  def can_manage_contact?(contact_id)
    contact = Contact.friendly.find(contact_id) rescue nil
    contact && contact.contactable == self
  end

  def can_manage_user?(user_id)
    return true if superuser?
    return true if user_id == id
    return false
  end

  def is_verified
    license_instances.where(verified_at: nil).size == 0
  end

  def can_control_review?(review_id)
    return false unless review_id
    reviews.find(review_id) rescue nil
  end

  def display_nickname
    nickname || first_name
  end

  def first_name
    name.nil? ? "" : name.split.first
  end

  private
  def notify_creation
    Delayed::Job.enqueue UserCreatedNotificationJob.new(id)
  end
end
