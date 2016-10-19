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
  { name: "Pet Friendly" },
  { name: "Wheelchair Accessible" },
  { name: "Washer/Dryer" },
  { name: "Electricity Included" },
  { name: "Gas Included" },
  { name: "Water Included" },
  { name: "Trash Included" },
  { name: "Central Air" },
  { name: "Indoor Fireplace" },
  { name: "Smoking Allowed" },
  { name: "Garage" },
  { name: "Lawn Care" },
]

amenities.each do |a|
  Amenity.find_or_create_by(name: a[:name])
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
