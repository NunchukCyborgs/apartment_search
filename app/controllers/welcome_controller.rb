class WelcomeController < ApplicationController
  skip_before_action :require_login

  def index
    @current_page = (params[:page] || 1).to_i
    @facets = PropertyFacet.get_new_facet_values({})
    @results = PropertyResults.returned_records({}, @current_page)
    @num_pages = (@facets[:total_count].to_i / Settings.properties_per_page) + 1
    @pages_to_display = (@num_pages > 5) ? 5 : @num_pages
  end
end
