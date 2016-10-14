require 'nokogiri'
require 'open-uri'
require 'active_support/core_ext/string'
require 'json'

class Property
  attr_accessor :address, :beds, :baths, :price, :description, :type, :pets, :garage, :school, :deposit, :images
end

doc = Nokogiri::HTML( open(ARGV[0]) )

main = doc.css('table#ctl00_ContentPlaceHolder1_Property1_dlRealEstate').first

properties = main.css('> tr').map do |el| 
  property = Property.new
  property.address = el.css('span[id$=MLS]').first.text
  property.price = el.css('span[id$=Price]').first.text
  property.beds = el.css('span[id$=Bed]').first.text
  property.baths = el.css('span[id$=Bath]').first.text
  property.type = el.css('span[id$=Type]').first.text
  property.school = el.css('span[id$=SchoolDistrict]').first.text
  property.pets = el.css('span[id$=Pets]').first.text
  property.garage = el.css('span[id$=Garage]').first.text
  property.description = el.css('span[id$=Description]').first.text
  property.deposit = el.css('span[id$=MinDeposit]').first.text
  image_link = el.css('a[id$=HyperLink1]').first
  property.images = image_link['href'] if image_link
  property
end


def prepare_property(property)
  {
    address1: property.address,
    bedrooms: property.beds,
    bathrooms: property.baths,
    price: property.price,
    description: "#{property.description} #{"In the #{property.school} district." unless(property.school.nil? || property.school.empty?)} #{"Minimum Deposit #{property.deposit}." unless(property.deposit.nil? || property.deposit.empty?)}",
    type: property.type,
    amenities: {
      pets: !(property.pets.nil? || property.pets.empty?),
      garage: !(property.garage.nil? || property.garage.empty?)
    }
  }
end

def write_prop_json(prop_hash, prop_folder)
  File.open("soto-images/#{prop_folder}/prop_data.json", "wb") do |file|
    file.puts prop_hash.to_json
  end
end

def process_images(image_link, prop_folder)
  doc = Nokogiri::HTML( open(image_link) )
  img_srcs = doc.css('input[type=image]').map{ |i| i['src'] }

  puts "images #{img_srcs.inspect}"

  mod_img_srcs = img_srcs.map do |src|
    match = src.match(/^(.*)\/thumbnails\/(.*)$/)
    match ? { url: match.captures[0], name: match.captures[1] } : nil
  end

  mod_img_srcs.each do |src|
    next unless src
    link = "#{src[:url]}/#{src[:name]}"
    puts "EACH LINK #{link}"
    open(link) do |f|
      name = File.basename(URI.parse(link).path)
      File.open("soto-images/#{prop_folder}/#{name}", "wb") do |file|
        file.puts f.read
      end
    end
  end
end

properties.each do |prop|
  prop_folder = prop.address.underscore
  puts prop_folder
  Dir.mkdir "soto-images/#{prop_folder}"
  process_images(prop.images, prop_folder) if prop.images
  prop_json = prepare_property(prop)
  write_prop_json(prop_json, prop_folder)
end

