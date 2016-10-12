json.properties do
  json.array! @user.properties.includes(:images, :amenities), partial: 'properties/property', as: :property
end

json.extract! @user, :email, :verified_at

json.license_id @user.license_value

if current_user.has_role? :superuser
  json.superuser true
end

json.contacts do
  json.array! @user.contacts, partial: 'contacts/contact', as: :contact
end
