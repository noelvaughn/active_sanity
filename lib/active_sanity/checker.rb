module ActiveSanity
  class Checker
    def self.check!
      new.check!
    end

    def check!
      puts "Sanity Check"
      puts "Checking the following models: #{models.join(', ')}"

      models.each do |model|
        model.find_each do |record|
          unless record.valid?
            invalid_record!(record)
          end
        end
      end
    end

    def models
      @models ||= Dir["#{Rails.root}/app/models/**/*.rb"].map do |file_path|
        basename  = File.basename(file_path, File.extname(file_path))
        klass     = basename.camelize.constantize
        klass.new.is_a?(ActiveRecord::Base) ? klass : nil
      end.compact
    end

    def invalid_record!(record)
      puts record.class.to_s + " | " + record.id.to_s + " | " + pretty_errors(record)
    end

    def pretty_errors(record)
      record.errors.inspect.sub(/^#<OrderedHash /, '').sub(/>$/, '')
    end
  end
end
