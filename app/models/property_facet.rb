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
      min_price: aggregations["min_price"]["value"].present? ? aggregations["min_price"]["value"] : 0,
      max_price: aggregations["max_price"]["value"].present? ? aggregations["max_price"]["value"] : 0,
      min_lease_length: aggregations["min_lease_length"]["value"],
      bedrooms: aggregations["bedrooms"]["buckets"].map { |b| b["key"] },
      bathrooms: aggregations["bathrooms"]["buckets"].map { |b| b["key"] },
      amenities: aggregations["amenities"]["buckets"].map { |b| b["key"] },
      locations: aggregations["locations"]["buckets"].map { |b| b["key"] },
      types: Type.all.map { |b| b.name }, # hack to have all types displayed all the time for now
      total_count: aggregations["total_count"]["value"],
      number_of_pages: number_of_pages
    }
  end

  private

  def number_of_pages
    (aggregations["total_count"]["value"].to_i / Settings.properties_per_page) + 1
  end

  def aggregations
    raw_results.fetch("aggregations")
  end

  def raw_results
    @raw_results ||= Property.search(query).response
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
        total_count: {
          value_count: { field: "id" }
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
