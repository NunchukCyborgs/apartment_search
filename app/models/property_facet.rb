class PropertyFacet

  def self.get_new_facet_values(facets)
    facetr = PropertyFacet.new(facets)
    facetr.get_new_facet_values
  end

  attr_accessor :filter_array

  def initialize(facets)
    @filter_array = PropertyFilter.filter_array(facets)
  end

  def get_new_facet_values
    {
      min_price: raw_results["min_price"]["value"],
      max_price: raw_results["max_price"]["value"],
      min_lease_length: raw_results["min_lease_length"]["value"],
      bedrooms: raw_results["bedrooms"]["buckets"].map { |b| b["key"] },
      bathrooms: raw_results["bathrooms"]["buckets"].map { |b| b["key"] },
      amenities: raw_results["amenities"]["buckets"].map { |b| b["key"] },
      locations: raw_results["locations"]["buckets"].map { |b| b["key"] },
      types: raw_results["types"]["buckets"].map { |b| b["key"] },
    }
  end

  private

  def raw_results
    @raw_results ||= Property.search(query).response.fetch("aggregations")
  end

  def query
    {
      size: 0,
      query: {
        filtered: {
          query: { match_all: {} },
          filter: {
            bool: {
              filter: filter_array
            }
          }
        }
      },
      aggs: {
        property_ids: {
          terms: {
            field: "id",
            size: 0
          }
        },
        min_price: {
          min: { field: "price" }
        },
        max_price: {
          max: { field: "price" }
        },
        bedrooms: {
          terms: {
            field: "bedrooms",
            size: 0
          }
        },
        bathrooms: {
          terms: {
            field: "bathrooms",
            size: 0
          }
        },
        amenities: {
          terms: {
            field: "amenities.name.raw",
            size: 0
          }
        },
        types: {
          terms: {
            field: "types.name.raw",
            size: 0
          }
        },
        locations: {
          terms: {
            field: "locations.facet_name.raw",
            size: 0
          }
        },
        min_lease_length: {
          min: { field: "lease_length" }
        }
      }
    }
  end

end
