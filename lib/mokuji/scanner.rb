module Mokuji

	#
	# 	SCANNER
	# 	- Lists the directory contents in an Array (flat) or a Hash (nested)
	#
	# 	{ return => Array or Hash }
	#

	class Scanner
	
	
	
		attr_accessor :path_to_scan, :converting_method
		
		
		
		def execute
		
			# Validation
			raise "You can't scan nil, duh." unless path_to_scan
			raise "The directory you want to scan doesn't exist" unless File.directory?(path_to_scan)
			
			# Go to the directory
			Dir.chdir(path_to_scan)
			
			# Get the data
			data = case converting_method
			
				when :json then FlatArray::make
				when :html then NestedHashes::make
				
				else
					raise 'The given converting method is unknown'
			
			end
		
		end
		
		
		
		protected
		
		
		
		module FlatArray
		
			def self.make
			
				# Makes a flat array
				array = Dir.glob('**/**')
				array.sort!
			
			end
		
		end
		
		
		
		module NestedHashes
		
			def self.make
			
				# Directory (name)
				path = Dir.pwd
				path.chomp!('/')
				
				rindex = path.rindex('/') + 1
				directory_name = path.slice(rindex..-1)
				
				# Makes a hash with hashes in it
				NestedHashes::read_directory path, directory_name
			
			end
			
			def self.read_directory path, directory_name
			
				# Set
				hash = {
				
					'type' => 'directory',
					'name' => directory_name,
					'contents' => []
				
				}
				
				# Open the directory
				d = Dir.entries(path)
				
				# Sort it
				d.sort!
				
				# Going over each file and directory
				for x in d
				
					# Hide certain files/directories
					if x == '.' || x == '..' || x.slice(0) == '.' then; next; end
					
					# Stuff
					x_path = path + '/' + x
					
					if File.directory? x_path then
					
						hash['contents'] << NestedHashes::read_directory(x_path, x)
					
					else
					
						new_file_hash = {
							
							'type' => 'file',
							'name' => x
						
						}
						
						hash['contents'] << new_file_hash
					
					end
				
				end
				
				# Return
				return hash
			
			end
		
		end
	
	
	
	end # </Scanner>

end

