require 'mokuji'


describe 'Initializer' do


	before do
	
		# Set paths
		path_to_scan = File.expand_path('~/')
		export_path = File.expand_path('~/')
		
		# Go!
		m = Mokuji::Initializer.new
		m.path_to_scan = path_to_scan
		m.export_path = export_path
		m.converting_method = :json
		@dfi_json = m.execute
		
		m.converting_method = :html
		@dfi_html = m.execute
	
	end
	
	
	# JSON
	it do
	
		@dfi_json.should be_an_instance_of File
	
	end
	
	
	# HTML
	it do
	
		@dfi_html.should be_an_instance_of File
	
	end


end
