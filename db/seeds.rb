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
