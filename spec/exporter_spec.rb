require 'mokuji/exporter'


describe 'Exporter' do


	before do
	
		export_path = File.expand_path('~/')
		
		exporter = Mokuji::Exporter.new
		exporter.file_data = 'Wait what, aaarrrrspeccaaaahhh!'
		exporter.export_path = export_path
		@dfe = exporter.execute
		
		exporter.converting_method = :json
		@dfe_json = exporter.execute
		
		exporter.converting_method = :html
		@dfe_html = exporter.execute
	
	end
	
	
	# nil
	it do
	
		@dfe.should be_an_instance_of File
	
	end
	
	
	# JSON
	it do
	
		@dfe_json.should be_an_instance_of File
	
	end
	
	
	# HTML
	it do
	
		@dfe_html.should be_an_instance_of File
	
	end


end
