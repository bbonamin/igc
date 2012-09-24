module IGC
  module Geolocation
    # Public: Converts geocoordinates from mindec notation of IGC to dec notation
    #
    # long: The longitude from the igc file
    # lat:  The Latitude from the igc file
    # 
    # Example 
    #
    #   GeoLocation.to_dec("01343272E", "4722676N")  
    #   #=>[13.7212,47.37793333333333]
    #
    # Returns Longitude and Latitude in decimal notation
    def self.to_dec(long, lat)

      long_m = long.match(/^(\d{3})((\d{2})(\d{3}))(E|W)/)
      lat_m = lat.match(/^(\d{2})((\d{2})(\d{3}))(N|S)/)

      # Convert minutes to decimal
      long_dec = long_m[1].to_f + (long_m[2].to_f / 1000 / 60)
      lat_dec = lat_m[1].to_f + (lat_m[2].to_f / 1000 / 60)

      # Change signs according to direction
      long_dec *= (-1) if long_m[5] == "W"
      lat_dec *= (-1) if lat_m[5] == "S"

      return long_dec, lat_dec
    end
  end
end
