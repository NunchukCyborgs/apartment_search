class PropertyResults

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

  def parsed_results
    raw_es_results.response["hits"]["hits"].map { |r| r["_source"] }
  end

  def parsed_results_with_images
    parsed_results.map do |result|
      image = Image.find_by(imageable_id: result[:id], imageable_type: "Property")
      result[:image_url] = image.try(:url)
      result
    end
  end

  def returned_records
    raw_es_results.records
  end

  private

  def raw_es_results
    @raw_es_results ||= Property.search(query)
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

end
