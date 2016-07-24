# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

amenities = [
  "Pet Friendly", "Wheelchair Accessible", "Washer/Dryer", "Electricity Inclued",
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
  end
  puts property.inspect
  sleep 1
end
