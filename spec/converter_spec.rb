require 'mokuji/converter'


describe 'Converter' do


	before do
	
		converter = Mokuji::Converter.new
		converter.time = Time.now.strftime('%d %B %Y (%I:%M%p)')
		converter.data_from_scanner = ['immafile.rb']
		converter.converting_method = :json
		@dfc_json = converter.execute
		
		test_hash = {
		
			'type' => 'directory',
			'name' => 'Icid',
		'contents' => [ {'type' => 'file', 'name' => 'immafile.rb'} ]
		
		}
		
		converter.data_from_scanner = test_hash
		converter.converting_method = :html
		@dfc_html = converter.execute
	
	end
	
	
	# JSON
	it do
	
		@dfc_json.should be_an_instance_of String
	
	end
	
	
	it do
	
		# Parse the JSON that was just created
		# and see if it fits
		j = JSON.parse @dfc_json
		j['contents'].to_a.should be_an_instance_of Array
	
	end
	
	
	# HTML
	it do
	
		@dfc_html.should be_an_instance_of String
	
	end
	
	
	it do
	
		@dfc_html.should include '<html'
	
	end


end
