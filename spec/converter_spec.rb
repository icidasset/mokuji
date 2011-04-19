require 'mokuji/converter'

describe 'Converter' do
  before do
    @converter = Mokuji::Converter.new
    
    @test_data = {
      'type' => 'directory',
      'name' => 'Icid',
      'contents' => [ {'type' => 'file', 'name' => 'file.txt'} ]
    }
  end
  
  it "should include the validators module" do
    @converter.methods.should include :validate_configuration
  end
  
  # HTML
  it do
    Mokuji.configure 'output_type' => 'html'
    @df_html = @converter.convert @test_data
    
    @df_html.should be_an_instance_of String
    @df_html.should include '<html'
  end
  
  # JSON
  it do
    Mokuji.configure 'output_type' => 'json'
    @df_json = @converter.convert @test_data
    
    @df_json.should be_an_instance_of String
    @converter.json_valid?(@df_json).should be true
  end
end
