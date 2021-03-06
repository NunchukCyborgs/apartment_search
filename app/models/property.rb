# == Schema Information
#
# Table name: properties
#
#  id                      :integer          not null, primary key
#  address1                :string(255)
#  address2                :string(255)
#  zipcode                 :string(255)
#  price                   :integer
#  square_footage          :integer
#  contact_number          :string(255)
#  contact_email           :string(255)
#  latitude                :float(24)
#  longitude               :float(24)
#  description             :text(65535)
#  bedrooms                :integer
#  bathrooms               :float(24)
#  lease_length            :integer
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  rented_at               :date
#  parcel_number           :string(255)
#  slug                    :string(255)
#  license_id              :integer
#  available_at            :datetime
#  city                    :string(255)
#  state                   :string(255)
#  average_property_rating :float(24)
#  average_combined_rating :float(24)
#  units                   :integer
#
# Indexes
#
#  index_properties_on_license_id     (license_id)
#  index_properties_on_parcel_number  (parcel_number)
#  index_properties_on_slug           (slug) UNIQUE
#

class Property < ActiveRecord::Base
  extend FriendlyId
  friendly_id :address1, use: :slugged

  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  has_many :images, as: :imageable
  has_many :reviews
  belongs_to :license
  accepts_nested_attributes_for :images, reject_if: :all_blank, allow_destroy: true

  delegate :primary_contact, to: :license, prefix: true, allow_nil: true
  delegate :url, to: :main_image, prefix: true, allow_nil: true

  scope :like_address, ->(address_string) { where("address1 LIKE ?", "%#{address_string}%") }

  after_create :set_locations
  geocoded_by :full_address

  validates :address1, :zipcode, presence: true
  #for contact_number contact_email, maybe we default back to these properties
  #on the owner if they have not entered them for the property

  has_and_belongs_to_many :amenities,
    after_add: [ lambda { |p,a| p.__elasticsearch__.index_document } ],
    after_remove: [ lambda { |p,a| p.__elasticsearch__.index_document } ]

  has_and_belongs_to_many :types,
    after_add: [ lambda { |p,t| p.__elasticsearch__.index_document } ],
    after_remove: [ lambda { |p,t| p.__elasticsearch__.index_document } ]

  #could potentially fall within multiple zones
  has_and_belongs_to_many :locations,
   after_add: [ lambda { |p,l| p.__elasticsearch__.index_document } ],
   after_remove: [ lambda { |p,l| p.__elasticsearch__.index_document } ]


  def full_address
    address1 + " " + address2.to_s + " " + zipcode
  end

  #this is necessary to define assocations that get sent to elasticsearch
  def as_indexed_json(options={})
    self.as_json(
      methods: :landlord_rating,
      include: {
        amenities: { only: :name },
        types: { only: :name },
        locations: { }
      }
    )
  end

  def landlord_rating
    license.try(:average_landlord_rating)
  end

  def main_image
    images.first
  end

  def claimed?
    license.claimed?
  end

  def image_urls
    images.reduce(&:url)
  end

  private

  def set_locations
    Location.all.each do |location|
      if self.distance_to([location.latitude, location.longitude]) < 2 #miles
        self.locations << location
      end
    end
  end

end
