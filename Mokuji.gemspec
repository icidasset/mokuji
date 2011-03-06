# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require 'mokuji/version'


Gem::Specification.new do |s|

  s.name        = "mokuji"
  s.version     = Mokuji::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Icid Asset']
  s.email       = ['icid.asset@gmail.com']
  s.homepage    = 'http://icidasset.heroku.com/'
  s.summary     = %q{Mokuji makes lists from directories}
  s.description = %q{Make a list from the directory contents and export it in JSON or HTML}
  
  s.rubyforge_project = "mokuji"
  
  s.add_dependency 'json', '~> 1.5.1'
  s.add_dependency 'thor', '~> 0.14.6'
  
  s.add_development_dependency 'rspec', '~> 2.5'
  
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

end
