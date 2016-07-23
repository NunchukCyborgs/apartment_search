class PropertyFilter

  def self.filter_array(facets)
    filterer = PropertyFilter.new(facets)
    filterer.filter_array
  end

  attr_accessor :facets, :min_price, :max_price, :min_bedrooms, :min_bathrooms,
    :max_lease_length, :amenities, :types, :locations


  def initialize(facets)
    @facets = facets || {}
    @min_price = @facets[:min_price].to_i if @facets[:min_price]
    @max_price = @facets[:max_price].to_i if @facets[:max_price]
    @min_bedrooms = @facets[:min_bedrooms].to_i if @facets[:min_bedrooms]
    @min_bathrooms = @facets[:min_bathrooms].to_i if @facets[:min_bathrooms]
    @max_lease_length = @facets[:max_lease_length].to_i if @facets[:max_lease_length]
    @amenities = @facets.fetch(:amenities, []).map(&:to_s)
    @types = @facets.fetch(:types, []).map(&:to_s)
    @locations = @facets.fetch(:locations, []).map(&:to_s)
  end

  def filter_array
    arr = []
    arr << min_price_filter if min_price
    arr << max_price_filter if max_price
    arr << min_bedrooms_filter if min_bedrooms
    arr << min_bathrooms_filter if min_bathrooms
    arr << max_lease_length_filter if max_lease_length
    arr << amenities_filter unless amenities.empty?
    arr << types_filter unless types.empty?
    arr << locations_filter unless locations.empty?
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
      "range" => {
        "price" => {
          "lte" => max_price
        }
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
      "terms" => { "amenities.name.raw" => amenities }
    }
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
