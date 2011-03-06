module Mokuji

	#
	# 	EXPORTER
	# 	- Exports the data to a file
	#

	class Exporter
	
	
	
		attr_accessor :file_data, :converting_method, :file_name, :export_path
		
		
		
		def execute
		
			# Check
			fail_msg = "You forgot to set some variables."
			fail_msg << "Make sure you've set the path to scan and the converting method."
			
			raise fail_msg unless file_data || converting_method || export_path
			
			# Filename check
			@file_name = 'Untitled' unless file_name
			
			# Export path validation
			raise "The directory you want to export to doesn't exist" unless File.directory?(export_path)
			
			# Set file extension
			file_extension = case converting_method
			
				when :json then '.json'
				when :html then '.html'
				
				else '.txt'
			
			end
			
			# Change to the directory where the file should be saved
			Dir.chdir(export_path)
			
			# Creating the file
			File::open( file_name + file_extension, 'w' ) do |f|
			
				f << file_data
			
			end
		
		end
	
	
	
	end # </Exporter>

end

