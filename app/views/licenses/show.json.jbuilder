json.extract! @license, :value, :name, :landlord_name, :id

json.contacts do
  json.array! @license.contacts do |contact|
    json.extract! contact, :phone, :email, :id
  end
end
