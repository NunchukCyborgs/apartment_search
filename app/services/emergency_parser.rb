class EmergencyParser

  def initialize(meridian)
    @url = "http://www.cityofcapegirardeau.org/CrimeImport/#{DateTime.now.strftime("%m-%d-%y")} #{meridian}.xls"
  end

  def process
    require 'roo'
    begin
      temp = URI.parse(URI.escape(@url)).open
      xls = Roo::Spreadsheet.open(temp.path, extension: :xls)
      sheet = xls.sheet(xls.sheets.last)

      sheet.each(location: "Location", offense: "Offense", info: "Victim / Information", time: "TIME") do |hash|
        # not sure if we need to manipulate the location at all to determine if the address matches
        if hash[:location].present?
          latlong = Geocoder.coordinates("#{hash[:location]}, 63701")
          puts latlong
          property = Property.find_by(latitude: latlong[0], longitude: latlong[1])
          if property
            owner = property.owner
            if owner && owner.premium?
              crime = Crime.new(hash[:location], hash[:offense], hash[:info], hash[:time])
              EmergencyNotifier.notify(owner, property, crime).deliver!
              puts hash
            end
          end
          sleep 0.05
        end
      end

    rescue
      puts "WELL THAT FUCKED UP"
    end
  end
end
