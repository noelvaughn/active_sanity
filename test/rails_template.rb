# Rails template to build the sample app for features
# Original script https://github.com/gregbell/active_admin/blob/master/spec/support/rails_template.rb

# Create a cucumber database and environment
#gsub_file 'config/database.yml', /^test:.*\n/, "test: &test\n"
#gsub_file 'config/database.yml', /\z/, "\ncucumber:\n  <<: *test\n  database: db/cucumber.sqlite3"

# Generate some test models
generate :model, "post title:string body:text published_at:datetime author_id:integer category_id:integer"
inject_into_file 'app/models/post.rb', "  belongs_to :author, :class_name => 'User'\n  belongs_to :category\n  accepts_nested_attributes_for :author\n", :after => "class Post < ActiveRecord::Base\n"
generate :model, "user first_name:string last_name:string username:string"
inject_into_file 'app/models/user.rb', "  has_many :posts, :foreign_key => 'author_id'\n", :after => "class User < ActiveRecord::Base\n"
generate :model, 'category name:string description:text'
inject_into_file 'app/models/category.rb', "  has_many :posts\n", :after => "class Category < ActiveRecord::Base\n"

# Add active_sanity
append_file 'Gemfile', "gem 'active_sanity', :path => '../../'"

run "bundle"
rake "db:migrate"

