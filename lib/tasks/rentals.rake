namespace :rentals do
  desc "TODO"
  task slug: :environment do
    Property.find_each(&:save)
  end

  task import: :environment do
    require 'csv'
    require 'indirizzo'
    puts "Opening CSV"
    CSV.read("#{Rails.root}/db/property-seeds.csv", headers: true).each do |line|
      address = Indirizzo::Address.new(line["City_State_Zip"])
      property = Property.find_or_create_by(address1: line["Label_Address"]) do |prop|
        prop.zipcode = address.zip
        prop.city = address.city.first
        prop.state = address.state
        prop.latitude = line["Latitude"]
        prop.longitude = line["Longitude"]
        prop.lease_length = 12
      end

      property.license = License.find_or_create_by(value: line["License"]) do |license|
        license.name = line["Owner"]
        license.landlord_name = line["Landlord"]
      end
      property.save
      # 5.times{ property.amenities.push(Amenity.find(1 + Random.rand(Amenity.all.size - 1))) }

      puts property.inspect
    end
  end

  task :import_soto_data, [:directory] => :environment do |t, args|
    require 'json'
    puts args[:directory]
    json_file = Dir["#{args[:directory]}/*.json"].first
    puts json_file.inspect
    puts Dir[args[:directory]].inspect
    prop_json = JSON.parse(File.read(json_file))

    images = Dir["#{args[:directory]}/*.JPG"]

    properties = Property.like_address(prop_json["address1"])
    if(properties.size == 1)
      puts "Property found"
      property = properties.first
      property.update({
        bedrooms:    prop_json["bedrooms"],
        bathroos:    prop_json["bathrooms"],
        price:       prop_json["price"],
        description: prop_json["description"]
      })
      property.types << Type.find_by(name: prop_json["type"].lowercase)
      property.amenities << Amenity.pets if prop_json["amenities"]["pets"]
      property.amenities << Amenity.garage if prop_json["amenities"]["garage"]
      property.save

      images.each do |image_path|
        property.images << Image.create(file: File.open(image_path))
      end
      property.save
    else
      puts "Property NOT found"
    end
  end

end
