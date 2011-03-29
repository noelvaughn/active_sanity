namespace :db do
  desc "Check records sanity"
  task :check_sanity => :environment do
    ActiveSanity::Checker.check!
  end
end

