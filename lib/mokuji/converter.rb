module Mokuji

	#
	# 	CONVERTER
	# 	- Converts the data from the scanner to JSON or HTML
	#
	# 	{ return => String }
	#

	class Converter
	
	
	
		attr_accessor :data_from_scanner, :converting_method, :list_name, :time
		
		
		
		def execute
		
			# Data validation
			data_validation
			
			# Time check
			raise 'Time not set' unless time
			
			# Process the data
			data = case converting_method
			
				when :json then toJSON
				when :html then toHTML
			
			end
		
		end
		
		
		
		protected
		
		
		
		def data_validation
		
			# Check if the Object isn't empty
			if data_from_scanner.empty? then
			
				raise 'No data <.<'
			
			else
			
				case converting_method
				
					when :json then raise_error_unless_data_is(Array)
					when :html then raise_error_unless_data_is(Hash)
					
					else
						raise 'The given converting method is unknown'
				
				end
			
			end
		
		end
		
		
		
		def raise_error_unless_data_is thisClass
		
			# Check if the class of the data Object is what it should be
			if data_from_scanner.class != thisClass then
			
				raise 'If you want to convert data, it should be a(n): ' + thisClass.to_s
			
			end
		
		end
		
		
		
		def toJSON
		
			require 'json'
			
			hash = {
			
				"list_name"		=>	list_name,
				"made_on"		=>	time,
				"contents"		=>	data_from_scanner
			
			}
			
			hash.to_json
		
		end
		
		
		
		def toHTML
		
			# Convert the data from the scanner to html
			html_data = toHTML_readContentsFrom( data_from_scanner['contents'] )
			
			# Loading some assets
			assets_path = if defined? Mokuji::LIB_PATH then
						
							Mokuji::LIB_PATH + '/mokuji/assets/'
						
						else
						
						'./lib/mokuji/assets/'
						
						end
			
			minified_jquery = IO.read(assets_path + 'jquery-1.5.min.js')
			javascript_code = IO.read(assets_path + 'code.js')
			stylesheet = IO.read(assets_path + 'stylesheet.css')
			
			# And push everything into the html template
			html_template = %{
			
				<!doctype html>
				<html>
					<head>
						<meta charset="utf-8">
						<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
						<title>#{list_name}</title>
						<style>#{stylesheet}</style>
					</head>
					<body>
						<h1>#{list_name}</h1>
						<h2>#{time}</h2>
						<nav>
							<a id="expand_all">Expand all directories</a> ---
							<a id="close_all">Close all directories</a>
						</nav>
						<ul id="list">#{html_data}</ul>
					<script>#{minified_jquery}</script>
					<script>#{javascript_code}</script>
					</body>
				</html>
			
			}.strip.gsub(/\t/, '')
		
		end
		
		
		
		def toHTML_readContentsFrom array
		
			html = ''
			
			array.each do |hash|
			
				if hash['type'] == 'directory' then
				
					html << '<li class="directory"><span>' + hash['name'] + '</span>'
					html << '<ul>' + toHTML_readContentsFrom( hash['contents'] ) + '</ul></li>'
				
				else
				
					html << '<li class="file">' + hash['name'] + '</li>'
				
				end
			
			end
			
			return html
		
		end
	
	
	
	end # </Converter>

end
