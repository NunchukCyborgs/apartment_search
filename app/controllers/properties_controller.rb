class PropertiesController < ::ApplicationController
  before_action :authenticate_user!, except: [:facets, :filtered_results, :show, :search]
  #skip_authorization_check :only => [:facets, :filtered_results, :show]
  authorize_resource
  before_action :set_property, only: [:show, :update, :images, :delete_image]


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
  #   page (defaults to 1)
  #   per_page
  #   offset (defaults to 0, can be used to have different # of results on
  #   different pages without screwing up the math)
  # returns: array of properties
  def filtered_results
    results = PropertyResults.paginated_results(params[:facets], params[:page], params[:per_page], params[:offset], params[:query])
    respond_to do |format|
      format.json { render json: results.to_json }
    end
  end

  def search
    @properties = PropertySearchService.new(params[:per_page], params[:page], 6, params[:q])
  end

  def index
    render_404 and return unless current_user.has_role? :superuser
    @properties = PropertySearchService.new(params[:per_page], params[:page], 100, params[:q])
  end

  def show
    render json: { status: "Not Found" }, status: 404 and return unless @property
    respond_to do |format|
      format.json { render 'properties/show' }
    end
  end

  def update
    respond_to do |format|
      if PropertyUpdateService.new(@property, property_params).process
        format.json { render 'properties/show', status: :ok, location: @property }
      else
        format.json { render json: @property.errors, status: :unprocessable_entity }
      end
    end
  end

  def images
    if ImageCreateService.new(@property, params[:property][:files]).process
      render 'properties/show', status: :ok, location: @property
    else
      render json: @property.errors, status: :unprocessable_entity
    end
  end

  def user
    if current_user
      @properties = current_user.properties
      render 'properties/index', status: :ok
    else
      render json: { result: "failed" }, status: 404
    end
  end

  def delete_image
    image = Image.find(params[:image_id])
    if image.destroy
      render 'properties/show', status: :ok, location: @property
    else
      render json: @property.errors, status: :unprocessable_entity
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
    amenities_params = [:id, :_destroy]
    types_params = [:id, :_destroy]
    params.require(:property).permit(:address1, :address2, :zipcode, :price, :square_footage, :contact_number, :contact_email, :description, :rented_at, :bedrooms, :bathrooms, :lease_length, :available_at, images_attributes: images_params, amenities_attributes: amenities_params, types_attributes: types_params)
  end

  def create_property_image_params
    params.require(:property).permit(:files)
  end
end
