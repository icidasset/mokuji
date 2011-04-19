require 'mokuji/exporter'

describe 'Exporter' do
  before do
    @data_from_converter = 'Wait what, aaarrrrspeccaaaahhh!'
    @export_path = File.expand_path('~/') + '/Desktop/'
    
    @exporter = Mokuji::Exporter.new
    Mokuji.configure 'list_name' => 'Desktop'
  end
  
  it "should include the validators module" do
    @exporter.methods.should include :validate_configuration
  end
  
  it do
    Mokuji.configure 'output_type' => 'json'
    @df_json = @exporter.export @data_from_converter, @export_path
    
    @df_json.should be_an_instance_of File
    File::delete(@df_json)
  end
  
  it do
    Mokuji.configure 'output_type' => 'html'
    @df_html = @exporter.export @data_from_converter, @export_path
    
    @df_html.should be_an_instance_of File
    File::delete(@df_html)
  end

end
