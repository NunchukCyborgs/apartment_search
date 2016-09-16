json.properties do
  json.array! @user.properties, partial: 'properties/property', as: :property
end

json.extract! @user, :email

json.contacts do
  json.array! @user.contacts, partial: 'contacts/contact', as: :contact
end
