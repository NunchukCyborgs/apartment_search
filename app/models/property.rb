class Property < ActiveRecord::Base

  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  geocoded_by :full_address
  after_validation :geocode

  validates :address1, :zipcode, :price, :lease_length, presence: true

  #for contact_number contact_email, maybe we default back to these properties
  #on the owner if they have not entered them for the property 

  def full_address
    address1 + " " + address2.to_s + " " + zipcode
  end


end
