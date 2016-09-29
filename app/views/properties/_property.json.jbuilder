json.extract! property, :id, :address1, :address2, :zipcode, :price,
:square_footage, :contact_number, :contact_email, :latitude, :longitude,
:description, :rented_at, :bedrooms, :bathrooms, :lease_length, :created_at, :updated_at, :slug, :available_at
if current_user
  json.can_edit (current_user.can_manage_property?(property.id))
end
json.url property_url(property, format: :json)

if property.images.empty?
  json.images do
    json.array! [{id: nil, url: "https://maps.googleapis.com/maps/api/streetview?size=600x400&location=#{property.latitude},#{property.longitude}&key=#{ENV["STREETVIEW_API_KEY"]}", height: "400", width: "600" }], partial: "properties/image", as: :image
  end
else
  json.images do
    json.array! property.images, partial: "properties/image", as: :image
  end
end

json.reviews do
  json.array! property.reviews.includes(:user) do |review|
    json.partial! 'reviews/review', review: review
  end
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

json.owner do
  json.partial! "properties/contact", contact: property.license_primary_contact, license: property.license
end
