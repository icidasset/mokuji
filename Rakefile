require 'rubygems'


unless ENV['NOBUNDLE']

	begin
	
		require 'bundler'
		Bundler::GemHelper.install_tasks
		
	rescue LoadError
	
		puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
		
	end

end
