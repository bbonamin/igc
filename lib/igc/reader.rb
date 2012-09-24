module IGC
	class	Reader
		attr_reader :contents
		attr_reader :a_record

  	REGEX_H_DTE = /^hf(dte)((\d{2})(\d{2})(\d{2}))/i
  	REGEX_A = /^[a]([a-z\d]{3})([a-z\d]{3})?(.*)$/i
		REGEX_H = /^[h][f|o|p]([\w]{3})(.*):(.*)$/i
		REGEX_B = /^(B)(\d{2})(\d{2})(\d{2})(\d{7}[NS])(\d{8}[EW])([AV])(\d{5})(\d{5})/

		# Public : Initializes a new IGC::Reader instance, taking a file_path and filling the contents
		# 
		# file_path: string with the path to the igc file
		def initialize(file_path)
			f = File.open(file_path) do |file|
				@contents = file.read
			end

			unless @a_record = @contents.match(REGEX_A)
        raise "Invalid file format"
      end
		end

		# Public : Scans the contents to get the date of the IGC file.
		# 				 Gets an array with all the date information, and creates
		# 				 a new date object from the UTC date (DDMMYY)
		#
		# Returns the date of the IGC file.
		def date
			date_array = @contents.scan(REGEX_H_DTE)[0]
			date = Date.strptime(date_array[1],'%d%m%y')
		end

		# Public : Returns the A record of the file
		def device_id
			
		end
		# Public : Scans the contents to get all the IGC header information (Section H)
		#
		# Returns a hash with all the header keys as indexes and their values.
		def headers
			headers = @contents.scan(/^[h][f|o|p]([\w]{3})(.*):(.*)$/i)
			headers_hash = Hash.new
			headers.each do |h|
				headers_hash[h.first] = h.last.chomp
			end
			return headers_hash
		end

		# Public : Scans the contents to get all B records forming the path of the flight
		#
		# Returns a hash with the time as the key and an array with 
		def flight_path
			flight_path = {}
			b_records = @contents.scan(REGEX_B)

			gps_present = b_records.map{|b| b[8].to_i - b[7].to_i}.uniq

			# NOTE: The altitude is given by both the pressure sensor and gps, 
			# 			we should use the pressure altitude when it's present (b[8]),
			# 			otherwise, the should use the gps alt. For now we'll just
			# 			use the gps altitude.
			b_records.each do |b|

				# Gets the datetime from the file date + time of record
				time = DateTime.new(date.year, date.month, date.day, 
              b[1].to_i, b[2].to_i, b[3].to_i).to_s

				# Gets the position at that time by long, lat and alt.
				position = IGC::Geolocation.to_dec(b[5], b[4]) + [b[7].to_i]

				# Adds the time and position in the hash
				flight_path[time] = position
			end
			flight_path
		end

		# Public : Returns the content of the pilot from the headers
		def pilot
			headers[PILOT]  
		end

		# Public : Returns the type of glider from the headers
		def glider_type
			headers[GLIDER_TYPE]
		end

		# Public : Returns the glider id from the headers
		def glider_id
			headers[GLIDER_ID]
		end

		# Public : Returns the glider fin id from the headers
		def glider_fin_id
			headers[GLIDER_FIN_ID]
		end
		private

		# Three-letter key codes adjusted to match the FAI IGC format reference
		PILOT = 'PLT'
		SECOND_PILOT = 'CM2'
		GLIDER_TYPE = 'GTY'
		GLIDER_ID = 'GID'
		GPS_DATUM = 'DTM'
		FIRMWARE_VERSION = 'RFW'
		HARDWARE_VERSION = 'RHW'
		LOGGER_MODEL = 'FTY'
		GPS_MODEL = 'GPS'
		PRESSURE_SENSOR = 'PRS'
		GLIDER_FIN_ID = 'CID'
		GLIDER_CLASS = 'CCL'

	end
end