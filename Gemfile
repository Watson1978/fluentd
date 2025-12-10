source 'https://rubygems.org/'

gemspec

gem 'cool.io', git: "https://github.com/Watson1978/cool.io.git", branch: "debug"

local_gemfile = File.join(File.dirname(__FILE__), "Gemfile.local")
if File.exist?(local_gemfile)
  puts "Loading Gemfile.local ..." if $DEBUG # `ruby -d` or `bundle -v`
  instance_eval File.read(local_gemfile)
end
