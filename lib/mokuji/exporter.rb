require 'mokuji/validators'

module Mokuji
  #
  # { EXPORTER }
  #
  # === Info
  #
  # Exports the data to a file
  #
  # === How to use
  #
  # exporter = Mokuji::Exporter.new
  # exporter.export data_from_converter, export_path
  
  class Exporter
    include Mokuji::Validators
    
    def initialize
      validate_configuration
    end
    
    def export string, path
      validate_data_from_converter string
      validate_export_path path
      
      data_from_converter = string
      list_name = (Mokuji::configuration['list_name'] ||= 'Untitled')
      time = Time.now.strftime('%d_%B_%Y_(%I-%M%p)')
      file_name = "#{list_name}_-_#{time}"
      output_type = Mokuji::configuration['output_type']
      
      file_extension = case output_type
        when 'json'                 then 'json'
        when 'html', 'plain_html'   then 'html'
        when 'plain_text'           then 'txt'
      end
      
      Dir.chdir(path)
      
      File::open("#{file_name}.#{file_extension}", 'w') { |f| f << data_from_converter }
    end
  end # </Exporter>

end
