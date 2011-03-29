ENV['BUNDLE_GEMFILE'] = File.expand_path('../../../Gemfile', __FILE__)

require 'rubygems'
require "bundler"
Bundler.setup

system("rm ./test/rails_app/db/migrate/*create_invalid_records.rb")

raise unless File.directory?("test/rails_app") && system("cd test/rails_app && rake db:drop db:create db:migrate")

After do
  # Reset DB!
  User.delete_all
  Category.delete_all
  Post.delete_all
  InvalidRecord.delete_all if InvalidRecord.table_exists?
  %w(users categories posts invalid_records).each do |table|
    ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence WHERE name='#{table}'")
  end
end
