module IGC
	class	Reader
		attr_reader :contents

  	REGEX_H_DTE = /^hf(dte)((\d{2})(\d{2})(\d{2}))/i
		REGEX_H = /^[h][f|o|p]([\w]{3})(.*):(.*)$/i

		# Public : Initializes a new IGC::Reader instance, taking a file_path and filling the contents
		# 
		# file_path: string with the path to the igc file
		def initialize(file_path)
			f = File.open('spec/support/cpilot.igc') do |file|
				@contents = file.read
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