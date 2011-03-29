ENV['BUNDLE_GEMFILE'] = File.expand_path('../../../Gemfile', __FILE__)

require 'rubygems'
require "bundler"
Bundler.setup

Before do
  raise unless File.directory?("test/rails_app") && system("cd test/rails_app && rake db:drop db:create db:migrate")
end
