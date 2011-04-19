require 'mokuji/validators'

module Mokuji
  #
  # { SCANNER }
  #
  # ==== Info
  #
  # Lists the directory contents in nested hashes / arrays
  # Dot files are hidden by default
  #
  # ==== Output example : Hash
  #
  # example = {
  #  type: 'directory'
  #  name: 'I am an example'
  #  contents: [ directory_hash, file_hash, file_hash ]
  # }
  #
  # ==== How to use
  #
  # scanner           =   Mokuji::Scanner.new
  # scanner_results   =   scanner.scan '/usr/local/Cellar/'
  
  class Scanner
    include Mokuji::Validators
    
    attr_reader :path_to_scan
    
    def initialize
      validate_configuration
    end
    
    def scan path
      validate_import_path path
      @path_to_scan = path
      return make_collection
    end
    
    private
    
    def make_collection
      directory_name = File.basename(@path_to_scan)
      return read_directory(@path_to_scan, directory_name)
    end
      
    def read_directory path, directory_name
      # Create new hash
      hash = {
        'type' => 'directory',
        'name' => directory_name,
        'contents' => []
      }
      
      # Going over each file and directory
      d = Dir.entries(path).sort
      
      # Keep certain files/directories out of the list
      ['.', '..', '.DS_Store', 'Thumbs.db'].each { |str| d.delete str }
      
      # Optional
      d.delete_if { |x| x[0] === '.' } unless Mokuji::configuration['show_dot_files']
      
      # Loop over each item
      d.each do |x|
        x_path = path + '/' + x
        
        if File.directory? x_path
          hash['contents'] << read_directory(x_path, x)
        else
          new_file_hash = {
            'type' => 'file',
            'name' => x
          }
          
          hash['contents'] << new_file_hash
        end
      end
      
      # Return
      return hash
    end
  end # </Scanner>

end
