require 'mokuji/validators'
require 'mokuji/scanner'
require 'mokuji/converter'
require 'mokuji/exporter'

module Mokuji
  #
  # === Info
  #
  # Mokuji makes recursive lists of directories
  # and outputs it in html, plain-html, json or plain-text files.
  #
  # === How to use
  #
  # require 'mokuji'
  #
  # Mokuji.make_list import_path, export_path # export path is optional
  #
  # === You could also
  #
  # Mokuji.configure :hide_dot_files => false
  # Mokuji.make_list import_path # Make a list with the dot files included
  # Mokuji.configure :output_type => 'json'
  # Mokuji.make_list import_path # Make another list in the json format
  #
  # === Example with Thor
  #
  # begin
  #  Mokuji.configure options
  #  Mokuji.make_list import_path, export_path
  #  say "BOOM! DONE!", :green
  # rescue RuntimeError => error_message
  #  say error_message.to_s, :red
  # end
  
  LIB_PATH = File.expand_path File.dirname(__FILE__)
  
  DEFAULTS = {
    'show_dot_files'   =>  false,     # Scanner options
    'output_type'      =>  'html',   # Converter options
    'list_name'        =>  nil       # Global options
  }
  
  def self.configure options = {}
    Mokuji::Validators.validate_options(options)
    @config = unless @config
      DEFAULTS.merge(options)
    else
      @config.merge(options)
    end
  end
  
  def self.configuration
    return @config ||= DEFAULTS.clone
  end
  
  def self.make_list import_path, export_path = nil
    scan_results = self.scan import_path
    converter_results = self.convert(scan_results)
    export_path ||= import_path
    self.export converter_results, export_path
  end
  
  def self.scanner; Mokuji::Scanner.new; end
  def self.scan path
    return self.scanner.scan(path)
  end
  
  def self.converter; Mokuji::Converter.new; end
  def self.convert hash
    return self.converter.convert(hash)
  end
  
  def self.exporter; Mokuji::Exporter.new; end
  def self.export string, export_path
    return self.exporter.export(string, export_path)
  end
end
