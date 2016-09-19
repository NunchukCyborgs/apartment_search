json.extract! contact, :email, :phone if contact
json.owner_name owner.name if owner
json.landlord_name owner.landlord_name if owner
