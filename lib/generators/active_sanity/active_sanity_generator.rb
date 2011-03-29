module ActiveSanity
  module Generators
    class ActiveSanityGenerator < Rails::Generators::Base
      desc "Generate migration to create table 'invalid_records'"

      include Rails::Generators::Migration

      def self.source_root
         @source_root ||= File.join(File.dirname(__FILE__), 'templates')
      end

      def self.next_migration_number(dirname) #:nodoc:
        next_migration_number = current_migration_number(dirname) + 1
        if ActiveRecord::Base.timestamped_migrations
          [Time.now.utc.strftime("%Y%m%d%H%M%S"), "%.14d" % next_migration_number].max
        else
          "%.3d" % next_migration_number
        end
      end

      def create_migration_file
          migration_template 'create_invalid_records.rb', 'db/migrate/create_invalid_records.rb'
      end
    end
  end
end
