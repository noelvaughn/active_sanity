# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "active_sanity/version"

Gem::Specification.new do |s|
  s.name        = "active_sanity"
  s.version     = ActiveSanity::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["VersaPay", "Philippe Creux"]
  s.email       = ["philippe.creux@versapay.com"]
  s.homepage    = ""
  s.summary     = %q{Active Record databases Sanity Check }
  s.description = %q{Performs a sanity check on your database through active record validations.}

  s.add_dependency "rails", ">=3.0.0"

  s.add_development_dependency "rspec"
  s.add_development_dependency "cucumber"
  s.add_development_dependency "sqlite3"

  s.rubyforge_project = "active_sanity"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
