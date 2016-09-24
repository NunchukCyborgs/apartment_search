class PropertyUpdateService

  def initialize(property, params)
    @property = property
    @params = params
  end

  def process
    amenities = @params[:amenities_attributes]
    @property.update(@params.except(*[:amenities_attributes, :types_attributes]))
    # super ugly but functional - tries to build expected behavior
    if amenities.present?
      ids = amenities.collect { |val| val[:id] }
      amenity_records = Amenity.where(id: ids)
      amenities.each do |amenity|
        a = amenity_records.select { |val| val.id == amenity[:id] }
        unless amenity[:_destroy].present?
          @property.amenities << a unless @property.amenities.include?(a)
        else
          @property.amenities.delete(a) if @property.amenities.include?(a)
        end
      end
    end

    # please god save this method for it has sinned
    types = @params[:types_attributes]
    if types.present?
      ids = types.collect { |val| val[:id] }
      type_records = Type.where(id: ids)
      types.each do |type|
        t = type_records.select { |val| val.id type[:id] }
        unless type[:_destroy].present?
          @property.types << t unless @property.types.include?(t)
        else
          @property.types.delete(t) if @property.types.include?(t)
        end
      end
    end

    @property.save
  end
end
