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
      address = Indirizzo::Address.new("#{line["Label_Address"]} #{line["City_State_Zip"]}")
      property = Property.find_or_create_by(address1: line["Label_Address"]) do |prop|
        prop.zipcode = address.zip
        prop.city = address.city
        prop.state = address.state
        prop.latitude = line["Latitude"]
        prop.longitude = line["Longitude"]
        prop.lease_length = 12
      end

      property.license = License.find_or_create_by(value: line["License"]) do |license|
        license.name = line["Owner"]
        license.landlord_name = line["Landlord"]
      end
      # 5.times{ property.amenities.push(Amenity.find(1 + Random.rand(Amenity.all.size - 1))) }

      puts property.inspect
    end
  end

end
