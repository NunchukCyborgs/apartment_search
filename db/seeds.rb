# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#
roles = [
  {
    name: "Superuser"
  },
  {
    name: "Landlord"
  },
  {
    name: "Renter"
  }
]

roles.each do |r|
  Role.where(name: r[:name]).first_or_create
end


amenities = [
  {
    name: "Pet Friendly",
    icon: "fa-paw"
  },
  {
    name: "Wheelchair Accessible",
    icon: "fa-wheelchair"
  },
  {
    name: "Washer/Dryer",
    icon: nil ## Need me some new icons
  },
  {
    name: "Electricity Included",
    icon: "fa-bolt"
  },
  {
    name: "Gas Included",
    icon: nil ## Need me some new icons
  },
  {
    name: "Water Included",
    icon: "fa-tint"
  },
  {
    name: "Trash Included",
    icon: "fa-trash"
  },
  {
    name: "Central Air",
    icon: nil ## Need me some new icons
  },
  {
    name: "Indoor Fireplace",
    icon: "fa-fire"
  },
  {
    name: "Smoking Allowed",
    icon: nil ## Need me some new icons
  },
]

amenities.each do |a|
  Amenity.create(a)
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
  property = Property.find_or_create_by(address1: line["Location Address"]) do |prop|
    prop.zipcode = line["Zip"]
    prop.price = 500 + Random.rand(1499)
    prop.parcel_number = line["Parcel"]
    prop.square_footage = 300 + Random.rand(1000)
    prop.contact_number = "123-123-1234"
    prop.contact_email = "user@example.com"
    prop.description = "This is a beautiful house. It is very pretty. This house has many things you will love"
    prop.bedrooms = 1 + Random.rand(8)
    prop.bathrooms = 1 + Random.rand(4)
    prop.lease_length = 12
  end
  5.times{ property.amenities.push(Amenity.find(1 + Random.rand(Amenity.all.size - 1))) }

  puts property.inspect
  sleep 1
end
