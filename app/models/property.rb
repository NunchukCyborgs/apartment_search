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

  def get_fresh_facets(facets)
    {
      size: 0,
      query: {
        filtered: {
          query: { match_all: {} },
          filter: {
            and: and_array(facets)
          }
        }
      } 
      aggs: {
      }
    }
  end

  def and_array(facets)
    []
  end

  def as_indexed_json(options={})
    self.as_json(
      include: {
        amenities: { only: :name },
      }
    )
  end


end
