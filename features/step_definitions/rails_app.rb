Given /^I have a rails app with a Gemfile requiring 'active_sanity'$/ do
  unless File.directory?("test/rails_app")
    unless system "bundle exec rails new test/rails_app -m test/rails_template.rb"
      system("rm -fr test/rails_app")
      raise "Failed to generate test/rails_app"
    end
  end
end

When /^I run "([^"]*)"$/ do |command|
  puts @output = `cd ./test/rails_app && #{command}`
end

Then "show me the output" do
  puts @output
end

Then /^I should not see any invalid records$/ do
  @output.should include('Sanity Check')
  @output.should_not include('|')
end


