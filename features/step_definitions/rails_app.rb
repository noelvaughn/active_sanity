def setup_rails_app
  return if File.directory?("test/rails_app")

  unless system "bundle exec rails new test/rails_app -m test/rails_template.rb"
    system("rm -fr test/rails_app")
    raise "Failed to generate test/rails_app"
  end
end

Given /^I have a rails app using 'active_sanity'$/ do
  Dir["./test/rails_app/db/migrate/*create_invalid_records.rb"].each do |migration|
    raise unless system("rm #{migration}")
  end

  setup_rails_app

  require './test/rails_app/config/environment'
end

Given /^I have a rails app using 'active_sanity' with db storage$/ do
  setup_rails_app

  raise unless system("cd ./test/rails_app && rails generate active_sanity && rake db:migrate")

  require './test/rails_app/config/environment'

  # Reset connection
  ActiveRecord::Base.connection.reconnect!
  InvalidRecord.table_exists?
end

Given /^the database contains a few valid records$/ do
  User.create!(:first_name => "Greg", :last_name => "Bell", :username => "gregbell")
  User.create!(:first_name => "Sam",  :last_name => "Vincent", :username => "samvincent")
  Category.create!(:name => "Uncategorized")
  Post.create!(:author => User.first, :category => Category.first,
    :title => "How ActiveAdmin changed the world", :body => "Only gods knows how...",
    :published_at => 4.years.from_now)
end

Given /^the first user's username is empty and the first post category_id is nil$/ do
  User.first.update_attribute(:username, "")
  Post.first.update_attribute(:category_id, nil)
end

Given /^the first user's username is "([^"]*)"$/ do |username|
  User.first.update_attribute('username', username)
end

Given /^the first post category is set$/ do
  Post.first.update_attribute('category_id', Category.first.id)
end

Given /^the first post title is empty$/ do
  Post.first.update_attribute('title', '')
end


When /^I run "([^"]*)"$/ do |command|
  puts @output = `cd ./test/rails_app && #{command}; echo "RETURN:$?"`
  raise unless @output['RETURN:0']
end


Then /^I should see the following invalid records:$/ do |table|
  table.raw.each do |model, id, errors|
    @output.should =~ /#{model}\s+\|\s+#{id}\s+\|\s+#{Regexp.escape errors}/
  end
end

Then /^I should see "([^"]*)"$/ do |output|
  @output.should include(output)
end

Then /^I should not see any invalid records$/ do
  @output.should_not include('|')
end

Then /^the table "([^"]*)" should be empty$/ do |_|
  InvalidRecord.count.should == 0
end

Then /^the table "([^"]*)" should contain:$/ do |_, table|
  table.raw.each do |model, id, errors|
    invalid_record = InvalidRecord.where(:record_type => model, :record_id => id).first
    invalid_record.should be_an_instance_of(InvalidRecord)
    errors = eval(errors)
    errors.each do |k, v|
      begin
        invalid_record.validation_errors[k].should == v
      rescue RSpec::Expectations::ExpectationNotMetError => e
        # A bug in serialization of ordered hash get rid of the array of
        # errors. The following is stored in the db:
        # --- !omap 
        #   - :username: can't be blank
        #   - :username: is too short (minimum is 3 characters)
        #
        # You actually get the last error on an attribute only
        # 
        invalid_record.validation_errors[k].should == v.last
      end
    end
  end
end

Then /^the table "([^"]*)" should not contain errors for "([^"]*)" "([^"]*)"$/ do |_, model, id|
    InvalidRecord.where(:record_type => model, :record_id => id).first.should be_nil
end

