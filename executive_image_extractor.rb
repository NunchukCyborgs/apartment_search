require 'nokogiri'
require 'open-uri'
require 'pry'

doc = Nokogiri::HTML( open(ARGV[0]) )
img_srcs = doc.css('img').map{ |i| i['src'] }

puts "images #{img_srcs.inspect}"

mod_img_srcs = img_srcs.map do |src|
  match = src.match(/^(.*\/(.*))\/small\.jpg$/)
  match ? { url: match.captures[0], name: match.captures[1] } : nil
end

puts "img srcs #{mod_img_srcs}"
mod_img_srcs.each do |src|
  next unless src
  link = "#{src[:url]}/large.jpg" 
  puts "EACH LINK #{link}"
  open(link) do |f|
    File.open("executive-images/#{src[:name]}.jpg", "wb") do |file|
      file.puts f.read
    end
  end
end
