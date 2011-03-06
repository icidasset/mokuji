require 'mokuji/scanner'


describe 'Scanner' do


	before do
	
		path_to_scan = File.expand_path('~/') + '/'
		
		scanner = Mokuji::Scanner.new
		scanner.path_to_scan = path_to_scan
		scanner.converting_method = :json
		@dfs_json = scanner.execute
		
		scanner.converting_method = :html
		@dfs_html = scanner.execute
	
	end
	
	
	# JSON
	it do
	
		@dfs_json.should be_an_instance_of Array
	
	end
	
	
	it do
	
		@dfs_json.should have_at_least(1).items
	
	end
	
	
	# HTML
	it do
	
		@dfs_html.should be_an_instance_of Hash
	
	end
	
	
	it do
	
		@dfs_html['contents'].should have_at_least(1).items
	
	end


end
