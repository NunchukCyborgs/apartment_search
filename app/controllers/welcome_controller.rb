class WelcomeController < ApplicationController
  skip_before_action :require_login

  def index
    @facets = PropertyFacet.get_new_facet_values({})
  end
end
