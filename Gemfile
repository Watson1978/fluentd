source 'https://rubygems.org/'

gemspec

gem 'rr', git: 'https://github.com/Watson1978/rr.git', branch: 'test'

local_gemfile = File.join(File.dirname(__FILE__), "Gemfile.local")
if File.exist?(local_gemfile)
  puts "Loading Gemfile.local ..." if $DEBUG # `ruby -d` or `bundle -v`
  instance_eval File.read(local_gemfile)
end
