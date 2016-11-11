class PropertyResults

  #returns hash with total results and an array of hashes directly from ES which includes main image url
  def self.paginated_results(facets, page = 1, per_page = Settings.properties_per_page, search_query = "")
    resultr = PropertyResults.new(facets, page, per_page, search_query)
    resultr.paginated_results
  end

  #returns array of hashes directly from ES
  def self.parsed_results(facets, page = 1, per_page = Settings.properties_per_page, search_query = "")
    resultr = PropertyResults.new(facets, page, per_page, search_query)
    resultr.parsed_results
  end

  #returns array of hashes directly from ES which includes main image url
  def self.parsed_results_with_images(facets, page = 1, per_page = Settings.properties_per_page, search_query = "")
    resultr = PropertyResults.new(facets, page, per_page, search_query)
    resultr.parsed_results_with_images
  end

  #returns an array of the ActiveRecord objects that match the facets
  def self.returned_records(facets, page = 1, per_page = Settings.properties_per_page, search_query = "")
    resultr = PropertyResults.new(facets, page, per_page, search_query)
    resultr.returned_records
  end

  attr_accessor :filter_array, :page, :per_page, :offset

  def initialize(facets, page = 1, per_page = Settings.properties_per_page, offset = 0 search_query="")
    @filter_array = PropertyFilter.filter_array(facets)
    #using OR here to ensure defaults if 'nil' is entered as a value
    @page = page || 1
    @per_page = per_page || Settings.properties_per_page
    @offset = offset || 0
    @search_query = search_query
  end

  def paginated_results
    {
      results: parsed_results_with_images,
      total_count: raw_es_results.response["hits"]["total"]
    }
  end

  def parsed_results_with_images
    parsed_results.map do |result|
      images = Image.where(imageable_id: result[:id], imageable_type: "Property")
      images = [FakeImage.new(nil, "https://maps.googleapis.com/maps/api/streetview?size=600x400&location=#{result[:latitude]},#{result[:longitude]}&key=#{ENV["STREETVIEW_API_KEY"]}", "400", "600")] if images.empty?
      result[:images] = images_result(images)
      result
    end
  end

  def parsed_results
    raw_es_results.response["hits"]["hits"].map { |r| r["_source"] }
  end

  def returned_records
    raw_es_results.records
  end

  private

  def raw_es_results
    @raw_es_results ||= Property.search(query)
  end

  def image_hash(image)
    {
      id: image.id,
      url: image.url,
      height: image.height,
      width: image.width
    }
  end

  def images_result(images)
    images.map { |image| image_hash(image) }
  end

  def query
    q = {
      size: per_page,
      from: calculate_from,
      sort: [
        { average_combined_rating: { order: "desc" } }
      ],
      query: {
        filtered: {
          query: { match_all: {} },
          filter: {
            bool: {
              filter: filter_array
            }
          }
        }
      }
    }
    q[:query][:filtered][:query] = { query_string: { query: @search_query, fields: [ "address1^3", "address2", "city", "state", "zipcode" ] } } if @search_query.present?
    q
  end

  def calculate_from
    ((page - 1) * per_page) - offset rescue 0
  end

  class FakeImage
    attr_accessor :id, :url, :height, :width

    def initialize(id, url, height, width)
      @id = id
      @url = url
      @height = height
      @width = width
    end
  end

end
