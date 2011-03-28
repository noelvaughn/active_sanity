module ActiveSanity
  require File.dirname(__FILE__) + '/active_sanity/railtie'

  def self.check!
    puts "Sanity Check"
  end
end
