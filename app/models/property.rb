class Property < ActiveRecord::Base

  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  geocoded_by :full_address

  after_validation :geocode, if: ->(obj) do
    (obj.address1.present? && obj.address1_changed?) ||
    (obj.address2.present? && obj.address2_changed?) ||
    (obj.zipcode.present? && obj.zipcode_changed?)
  end

  after_save :set_locations

  validates :address1, :zipcode, :price, :lease_length, presence: true
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
      include: {
        amenities: { only: :name },
        types: { only: :name },
        locations: { }
      }
    )
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
