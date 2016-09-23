json.extract! contact, :email, :phone if contact
json.owner_name license.name if license
json.landlord_name license.landlord_name if license
