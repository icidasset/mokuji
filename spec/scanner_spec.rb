require 'mokuji/scanner'

describe 'Scanner' do
  before do
    @path_to_scan = File.expand_path('~/') + '/Downloads/'
    @directory_name = File.basename(@path_to_scan)
    
    @scanner = Mokuji::Scanner.new
    @results = @scanner.scan @path_to_scan
  end
  
  it "should include the validators module" do
    @scanner.methods.should include :validate_configuration
  end
  
  it do
    @results.should be_an_instance_of Hash
  end
  
  it do
    @results['type'].should == 'directory'
  end
  
  it do
    @results['name'].should == @directory_name
  end
  
  it do
    @results['contents'][0]['name'].should_not == '.'
  end
  
  it do
    @results['contents'].should have_at_least(1).items
  end
end
