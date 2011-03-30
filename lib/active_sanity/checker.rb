module ActiveSanity
  class Checker
    def self.check!
      new.check!
    end

    def check!
      puts "Sanity Check"
      puts "Checking the following models: #{models.join(', ')}"

      check_previously_invalid_records
      check_all_records
    end

    def models
      # Ensure ActiveRecord::Base is aware of all models under
      # app/models
      Dir["#{Rails.root}/app/models/**/*.rb"].each do |file_path|
        require file_path rescue nil
      end
      
      @models ||= ActiveRecord::Base.subclasses 
    end

    protected

    def check_previously_invalid_records
      return unless InvalidRecord.table_exists?

      InvalidRecord.find_each do |invalid_record|
        invalid_record.destroy if invalid_record.record.valid?
      end
    end

    def check_all_records
      models.each do |model|
        begin
          model.find_each do |record|
            unless record.valid?
              invalid_record!(record)
            end
          end
        rescue => e
          # Rescue from exceptions (table does not exists,
          # deserialization error, ...)
          puts e.message
          puts "Skipping validations for #{model}"
        end
      end
    end

    def invalid_record!(record)
      log_invalid_record(record)
      store_invalid_record(record)
    end

    def log_invalid_record(record)
      puts record.class.to_s + " | " + record.id.to_s + " | " + pretty_errors(record)
    end
    
    def store_invalid_record(record)
      return unless InvalidRecord.table_exists?

      invalid_record = InvalidRecord.where(:record_type => record.type, :record_id => record.id).first
      invalid_record ||= InvalidRecord.new
      invalid_record.record = record
      invalid_record.validation_errors = record.errors
      invalid_record.save!
    end

    def pretty_errors(record)
      record.errors.inspect.sub(/^#<OrderedHash /, '').sub(/>$/, '')
    end
  end
end
