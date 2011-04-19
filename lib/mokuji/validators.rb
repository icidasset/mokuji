module Mokuji
  #
  # { VALIDATORS }
  
  module Validators
    def self.validate_options hash
      if hash['output_type']
        unless ['json', 'html', 'plain_html', 'plain_text'].include? hash['output_type']
          raise "Sorry, but, this output type is unknown."
        end
      end
    end
    
    def validate_configuration
      unless Mokuji.method_defined? :configuration
        begin
          require 'mokuji'
        rescue LoadError
          raise "What have you done with this gem? 'mokuji.rb' is missing!"
        end
      end
    end
    
    def validate_import_path path
      case
      when !File.directory?(path)
        raise "Arr, that directory you want to scan, it doesn't quite exist."
      when Dir.entries(path).slice(2..-1).empty?
        raise "Arr, that directory you want to scan, it's empty."
      end
    end
    
    def validate_export_path path
      case
      when !File.directory?(path)
        raise "Arr, that directory you want to export to, it doesn't quite exist."
      end
    end
    
    def validate_data_from_scanner hash
      case
      when hash.class ==! Hash
        raise "Wait a minute, this isn't a hash!"
      when hash.empty?
        raise "This hash is empty. Lame!"
      end
    end
    
    def validate_data_from_converter string
      case
      when string.class ==! String
        raise "Wait a minute, this isn't a string!"
      when string.length === 0
        raise "The length of this string is zero. Lame!"
      end
    end
    
    def json_valid? str
      begin
        JSON.parse str
        return true
      rescue JSON::ParserError
        return false
      end
    end
  end # </Validators>
end