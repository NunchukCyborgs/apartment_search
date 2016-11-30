class PropertySearchService

  def initialize(per_page, page, default_per_page, query)
    @per_page = per_page || default_per_page
    @page = page || 1
    @query = query
  end

  def seach
    response = @query.present? ? Property.search(@query).records.limit(@per_page) : Property.limit(@per_page)
    response.offset((@page - 1) * @per_page).includes(:images, :amenities, reviews: :user)
  end
end
