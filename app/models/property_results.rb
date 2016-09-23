class PropertyResults

  #returns hash with total results and an array of hashes directly from ES which includes main image url
  def self.paginated_results(facets, page = 1, per_page = Settings.properties_per_page)
    resultr = PropertyResults.new(facets, page, per_page)
    resultr.paginated_results
  end

  #returns array of hashes directly from ES
  def self.parsed_results(facets, page = 1, per_page = Settings.properties_per_page)
    resultr = PropertyResults.new(facets, page, per_page)
    resultr.parsed_results
  end

  #returns array of hashes directly from ES which includes main image url
  def self.parsed_results_with_images(facets, page = 1, per_page = Settings.properties_per_page)
    resultr = PropertyResults.new(facets, page, per_page)
    resultr.parsed_results_with_images
  end

  #returns an array of the ActiveRecord objects that match the facets
  def self.returned_records(facets, page = 1, per_page = Settings.properties_per_page)
    resultr = PropertyResults.new(facets, page, per_page)
    resultr.returned_records
  end

  attr_accessor :filter_array, :page, :per_page

  def initialize(facets, page = 1, per_page = Settings.properties_per_page)
    @filter_array = PropertyFilter.filter_array(facets)
    @page = page
    @per_page = per_page
  end

  def paginated_results
    {
      results: parsed_results_with_images,
      total_count: raw_es_results.response["hits"]["total"]
    }
  end

  def parsed_results_with_images
    start_time = Time.now.to_i
    Rails.logger.info("Calling elasticsearch...")
    parsed_results.map do |result|
      images = Image.where(imageable_id: result[:id], imageable_type: "Property")
      images = [FakeImage.new(nil, "https://maps.googleapis.com/maps/api/streetview?size=600x400&location=#{result[:latitude]},#{result[:longitude]}&key=#{ENV["STREETVIEW_API_KEY"]}")] if images.empty?
      result[:images] = images_result(images)
      result
    end
    end_time = Time.now.to_i
    total_time = end_time - start_time
    Rails.logger.info("Finished calling elasticsearch in #{total_time}")

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
      url: image.url
    }
  end

  def images_result(images)
    images.map { |image| image_hash(image) }
  end

  def query
    {
      size: per_page,
      from: calculate_from,
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
  end

  def calculate_from
    (((page - 1) * per_page) + 1) rescue 0
  end

  class FakeImage
    attr_accessor :id, :url

    def initialize(id, url)
      @id = id
      @url = url
    end
  end

end
