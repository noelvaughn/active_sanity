require 'active_sanity'
require 'rails'

module ActiveSanity
  class Railtie < Rails::Railtie
    rake_tasks do
      load 'active_sanity/tasks.rb'
    end
  end
end

