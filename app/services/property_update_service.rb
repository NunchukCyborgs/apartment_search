class PropertyUpdateService

  def initialize(property, params)
    @property = property
    @params = params
  end

  def process
    amenities = @params[:amenities_attributes]
    @property.update(@params.except(:amenities_attributes))
    # super ugly but functional - tries to build expected behavior
    if amenities.present?
      amenities.each do |amenity|
        a = Amenity.find(amenity[:id])
        unless amenity[:_destroy].present?
          @property.amenities << a unless @property.amenities.include?(a)
        else
          @property.amenities.delete(a) if @property.amenities.include?(a)
        end
      end
    end
    @property.save
  end
end
