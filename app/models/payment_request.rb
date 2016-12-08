# == Schema Information
#
# Table name: payment_requests
#
#  id                :integer          not null, primary key
#  user_id           :integer
#  property_id       :integer
#  verified_at       :datetime
#  potential_address :text(65535)
#  due_on            :integer
#  name              :string(255)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  subtotal          :float(24)
#  unit              :string(255)
#  token             :string(255)
#
# Indexes
#
#  index_payment_requests_on_property_id  (property_id)
#  index_payment_requests_on_token        (token)
#  index_payment_requests_on_user_id      (user_id)
#

class PaymentRequest < ActiveRecord::Base
  belongs_to :user
  belongs_to :property

  has_one :payment
  has_one :contact, as: :contactable

  validates :property_id, presence: true

  accepts_nested_attributes_for :contact, reject_if: :all_blank, allow_destroy: true

  delegate :address1, :address2, to: :property, allow_nil: true, prefix: true

  after_create :generate_token

  def description
    "Payment made for #{property_address1}#{" unit: #{property_address2}" if property_address2.present?} by #{name}."
  end

  def amount_in_cents
    (subtotal * 100).to_i
  end

  def total
    subtotal + PaymentFeeService.new(subtotal).fees
  end

  private

  def generate_token
    update(token: Digest::SHA1.hexdigest("#{self.to_s}-#{self.id}-#{self.created_at}-[roomhere-#{self.id.to_s(36)}]-[#{rand(-200..200).days.ago}]"))
  end
end
