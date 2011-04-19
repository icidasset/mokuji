require 'mokuji/validators'

module Mokuji
  #
  # { CONVERTER }
  #
  # === Info
  #
  # Converts the data from the scanner to JSON or HTML
  #
  # === Output example : String
  #
  # <html>
  #  ...
  #  <body>
  #   <h1>Icid</h1>
  #   <h2>19 April 2011 (03:47PM)</h2>
  #   <nav>
  #    <a id="expand_all">Expand all directories</a> ---
  #    <a id="close_all">Close all directories</a>
  #   </nav>
  #   <ul id="list"><li class="file">file.txt</li></ul>
  #  </body>
  #  ...
  # </html>
  #
  # === How to use
  #
  # converter           =   Mokuji::Converter.new
  # converter_results   =   converter.convert data_from_scanner

  class Converter
    include Mokuji::Validators
    
    attr_reader :data_from_scanner, :output_type, :list_name, :time
    
    def initialize
      validate_configuration
    end
    
    def convert hash
      validate_data_from_scanner hash
      
      @data_from_scanner = hash
      @output_type = Mokuji::configuration['output_type']
      @list_name = (Mokuji::configuration['list_name'] ||= hash['name'])
      @time = Time.now.strftime('%d %B %Y (%I:%M%p)')
      
      return data = case output_type
        when 'json' then to_json
        when 'html' then to_html
        when 'plain_html' then to_html_plain
        when 'plain_text' then to_plain_text
      end
    end
    
    private
    
    def to_json
      require 'json'
      
      hash = {
        'list_name' => list_name,
        'made_on' => time,
        'contents' => data_from_scanner.to_json
      }
      
      return hash.to_json
    end
    
    def to_html
      # Convert the data from the scanner to html
      html_data = to_html__read_directory data_from_scanner['contents']
      
      # Loading some assets
      assets_path = File.join Mokuji::LIB_PATH, '/mokuji/assets/'
      
      minified_jquery = IO.read("#{assets_path}jquery-1.5.min.js")
      javascript_code = IO.read("#{assets_path}code.js")
      stylesheet = IO.read("#{assets_path}stylesheet.css")
      
      # And push everything into the html template
      return html_template = %Q{
        <!doctype html>
        <html>
          <head>
            <meta charset="utf-8">
            <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
            <title>#{list_name}</title>
            <style>#{stylesheet}</style>
          </head>
          <body>
            <h1>#{list_name}</h1>
            <h2>#{time}</h2>
            <nav>
              <a id="expand_all">Expand all directories</a> ---
              <a id="close_all">Close all directories</a>
            </nav>
            <ul id="list">#{html_data}</ul>
          <script>#{minified_jquery}</script>
          <script>#{javascript_code}</script>
          </body>
        </html>
      }.strip.gsub(/^(\s){8}/, '')
    end
    
    def to_html_plain
      # Convert the data from the scanner to plain html
      html_data = to_html__read_directory data_from_scanner['contents']
      
      # And push everything into the html template
      return html_template = %Q{
        <!doctype html>
        <html>
          <head>
            <meta charset="utf-8">
            <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
            <title>#{list_name}</title>
          </head>
          <body>
            <h1>#{list_name}</h1>
            <h2>#{time}</h2>
            <ul id="list">#{html_data}</ul>
          </body>
        </html>
      }.strip.gsub(/^(\s){8}/, '')
    end
    
    def to_html__read_directory array
      html = ''
      
      array.each do |hash|
        case hash['type']
        when 'directory'
          html << "<li class='directory'><span>#{hash['name']}</span>"
          html << "<ul>#{to_html__read_directory(hash['contents'])}</ul></li>"
        when 'file'
          html << "<li class='file'>#{hash['name']}</li>"
        end
      end
      
      return html
    end
    
    def to_plain_text
      # Convert the data from the scanner to plain text
      return to_plain_text__read_directory '', data_from_scanner['contents']
    end
    
    def to_plain_text__read_directory path, array
      text = ''
      
      array.each do |hash|
        text << "#{path}#{hash['name']}\n"
        text << to_plain_text__read_directory("#{path}#{hash['name']}/", hash['contents']) if hash['type'] === 'directory'
      end
      
      return text
    end
  end # </Converter>

end
