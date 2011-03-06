require 'mokuji/scanner'
require 'mokuji/converter'
require 'mokuji/exporter'

module Mokuji

	#
	# 	INITIALIZER
	# 	- Initialises the whole thing
	#

	class Initializer
	
	
	
		attr_accessor :path_to_scan, :converting_method, :list_name, :time, :export_path
		
		
		
		def execute
		
			# Validation
			fail_msg = "You forgot to set some variables."
			fail_msg << "Make sure you've set the path to scan and the converting method."
			
			raise fail_msg unless path_to_scan || converting_method
			
			# List name
			unless list_name then
			
				rindex = path_to_scan.chomp('/').rindex('/') + 1
				@list_name = path_to_scan.chomp('/').slice(rindex..-1)
			
			end
			
			# Time
			@time = Time.now.strftime('%d %B %Y (%I:%M%p)')
			
			# Export path
			@export_path = path_to_scan unless export_path
			
			# Let's begin
			data_from_scanner = scan(path_to_scan)
			file_contents = convert(data_from_scanner)
			export(file_contents)
		
		end
		
		
		
		protected
		
		
		
		def scan path
		
			scanner = Mokuji::Scanner.new
			scanner.path_to_scan = path
			scanner.converting_method = converting_method
			scanner.execute
		
		end
		
		
		
		def convert data_from_scanner
		
			converter = Mokuji::Converter.new
			converter.data_from_scanner = data_from_scanner
			converter.converting_method = converting_method
			converter.list_name = list_name
			converter.time = time
			converter.execute
		
		end
		
		
		
		def export file_contents
		
			exporter = Mokuji::Exporter.new
			exporter.file_data = file_contents
			exporter.converting_method = converting_method
			exporter.file_name = list_name + '_-_' + time.gsub(' ', '_').gsub(':', '-')
			exporter.export_path = export_path
			exporter.execute
		
		end
	
	
	
	end # </Initializer>

end

