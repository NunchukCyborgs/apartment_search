json.extract! property, :id, :address1, :address2, :zipcode, :price,
:square_footage, :contact_number, :contact_email, :latitude, :longitude,
:description, :rented_at, :bedrooms, :bathrooms, :lease_length, :owner_id, :created_at, :updated_at, :slug
json.url property_url(property, format: :json)
json.images do
  json.array! property.images, partial: "properties/image", as: :image
end
