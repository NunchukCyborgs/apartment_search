# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

amenities = [
  "Pet Friendly", "Wheelchair Accessible", "Washer/Dryer", "Electricity Included",
  "Gas Included", "Water Included", "Trash Included", "Central Air", "Indoor Fireplace",
  "Smoking Allowed"
]

amenities.each do |a|
  Amenity.where(name: a).first_or_create
end

types = [
  "Apartment", "Single Family Home", "Duplex", "Triplex"
]

types.each do |t|
  Type.where(name: t).first_or_create
end

locations = [
  {
    full_name: "SEMO University",
    facet_name: "Near College",
    data_name: "near_college",
    latitude: 37.3124913,
    longitude: -89.5310413
  },
  {
    full_name: "Southeast Hospital",
    facet_name: "Near Hospital",
    data_name: "near_hospital",
    latitude: 37.311372,
    longitude: -89.539869
  },
  {
    full_name: "Downtown",
    facet_name: "Near Downtown",
    data_name: "near_downtown",
    latitude: 37.303957,
    longitude: -89.519235
  }

]

locations.each do |l|
  Location.where(l).first_or_create
end

require 'csv'
puts "Opening CSV"
CSV.read("#{Rails.root}/db/property-seeds.csv", headers: true).first(100).each do |line|
  puts line.inspect
  puts line["Parcel"]
  property = Property.find_or_create_by(parcel_number: line["Parcel"]) do |prop|
    prop.address1 = line["Location Address"]
    prop.zipcode = line["Zip"]
    prop.price = 500 + Random.rand(1499)
    prop.square_footage = 300 + Random.rand(1000)
    prop.contact_number = "123-123-1234"
    prop.contact_email = "user@example.com"
    prop.description = "This is a beautiful house. It is very pretty. This house has many things you will love"
    prop.bedrooms = 1 + Random.rand(8)
    prop.bathrooms = 1 + Random.rand(4)
    prop.lease_length = 12

  end
  puts property.inspect
  sleep 1
end
