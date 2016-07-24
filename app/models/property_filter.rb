class PropertyFilter

  def self.filter_array(facets)
    filterer = PropertyFilter.new(facets)
    filterer.filter_array
  end

  attr_accessor :facets, :min_price, :max_price, :min_bedrooms, :min_bathrooms,
    :max_lease_length, :amenities, :types, :locations


  def initialize(facets)
    @facets = facets || {}
    @min_price = @facets[:min_price].to_i unless @facets[:min_price].blank?
    @max_price = @facets[:max_price].to_i unless @facets[:max_price].blank?
    @min_bedrooms = @facets[:min_bedrooms].to_i unless @facets[:min_bedrooms].blank?
    @min_bathrooms = @facets[:min_bathrooms].to_i unless @facets[:min_bathrooms].blank?
    @max_lease_length = @facets[:max_lease_length].to_i unless @facets[:max_lease_length].blank?
    @amenities = @facets.fetch(:amenities, []).map(&:to_s)
    @types = @facets.fetch(:types, []).map(&:to_s)
    @locations = @facets.fetch(:locations, []).map(&:to_s)
  end

  def filter_array
    arr = []
    arr << min_price_filter if min_price && !min_price.blank? && min_price > 0
    arr << max_price_filter if max_price && !max_price.blank?
    arr << min_bedrooms_filter if min_bedrooms && !min_bedrooms.blank? && min_bedrooms > 0
    arr << min_bathrooms_filter if min_bathrooms && !min_bathrooms.blank? && min_bathrooms > 0
    arr << max_lease_length_filter if max_lease_length && !max_lease_length.blank?
    arr << amenities_filter unless amenities.empty? || amenities.all?(&:blank?)
    arr << types_filter unless types.empty? || types.all?(&:blank?)
    arr << locations_filter unless locations.empty? || locations.all?(&:blank?)
    arr
  end

  private

  def min_price_filter
    {
      "range" => {
        "price" => {
          "gte" => min_price
        }
      }
    }
  end

  def max_price_filter
    {
      "bool" => {
        "should" => [
          "range" => {
            "price" => {
              "lte" => max_price
            }
          },
          "term" => { "price" => nil }
        ]
      }
    }
  end

  def min_bedrooms_filter
    {
      "range" => {
        "bedrooms" => {
          "gte" => min_bedrooms
        }
      }
    }
  end

  def min_bathrooms_filter
    {
      "range" => {
        "bathrooms" => {
          "gte" => min_bathrooms
        }
      }
    }
  end

  def max_lease_length_filter
    {
      "range" => {
        "lease_length" => {
          "lte" => max_lease_length
        }
      }
    }
  end

  def amenities_filter
    {
      "bool" => {
        "must" => amenity_must_array
      }
    }
  end

  def amenity_must_array
    amenities.map do |amenity|
      { "term" => { "amenities.name.raw" => amenity } }
    end
  end

  def types_filter
    {
      "terms" => { "types.name.raw" => types }
    }
  end

  def locations_filter
    {
      "terms" => { "locations.facet_name.raw" => locations }
    }
  end

end
