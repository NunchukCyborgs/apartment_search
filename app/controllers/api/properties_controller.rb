module Api
  class PropertiesController < ::ApplicationController
    skip_before_action :require_login
    before_action :set_property, only: [:show, :update]

    #  Both of the following endpoints expect a list of facet filters to be sent
    #  This list will look something like:
    #
    #  facets: {
    #       min_price: 650,
    #       max_price: 850,
    #       min_bedrooms: 1,  # any with 1 or more will be returned
    #       min_bathrooms: 2, # any with 2 or more will be returned
    #       amenities: [
    #         “Gas Included”,
    #         “Pet Friendly”
    #       ],
    #       type: [
    #         “apartment”
    #       ],
    #       near: [
    #         “Downtown”
    #       ],
    #       max_lease_length: 6
    #     }


    # Get a facets list, this list will be filtered down and based on the facets
    # input to it, if no facets are given it will return all available values for
    # each facet
    # expects: facet hash (shown above)
    # returns: facet hash
    def facets
      facets = PropertyFacet.get_new_facet_values(params[:facets])
      respond_to do |format|
        format.json { render json: facets.to_json }
      end
    end

    # Return property results based on facet filters sent
    #
    # expects:
    #   facet hash (shown above)
    # optional:
    #   page
    #   per_page
    # returns: array of properties
    def filtered_results
      results = PropertyResults.parsed_results_with_images(params[:facets], params[:page], params[:per_page])
      respond_to do |format|
        format.json { render json: results.to_json }
      end
    end

    def show
      render json: { status: "Not Found" }, status: 404 and return unless @property
      respond_to do |format|
        format.json { render 'properties/show' }
      end
    end

    def update
      respond_to do |format|
        if @property.update(property_params)
          format.json { render 'properties/show', status: :ok, location: @property }
        else
          format.json { render json: @property.errors, status: :unprocessable_entity }
        end
      end
    end

    private

    def set_property
      begin
        @property = Property.friendly.find(params[:id])
      rescue
      end
    end

    def property_params
      images_params = [:id, :_destroy, :name, :file]
      params.require(:property).permit(:address1, :address2, :zipcode, :price, :square_footage, :contact_number, :contact_email, :description, :rented_at, :bedrooms, :bathrooms, :lease_length, images_attributes: images_params)
    end
  end

end
