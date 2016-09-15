json.extract! property, :id, :address1, :address2, :zipcode, :price,
:square_footage, :contact_number, :contact_email, :latitude, :longitude,
:description, :rented_at, :bedrooms, :bathrooms, :lease_length, :created_at, :updated_at, :slug
if current_user
  json.can_edit (current_user.has_role?(:superuser) || current_user.properties.include?(property))
end
json.url property_url(property, format: :json)
json.images do
  json.array! property.images, partial: "properties/image", as: :image
end

json.amenities do
  json.array! Amenity.all do |amenity|
    json.extract! amenity, :name, :icon, :id
    json.active property.amenities.include?(amenity)
  end
end

json.types do
  json.array! Type.all do |type|
    json.extract! type, :name, :id
    json.active property.types.include?(type)
  end
end
