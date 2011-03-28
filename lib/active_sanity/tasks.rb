namespace :db do
  desc "Check records sanity"
  task :check_sanity do
    ActiveSanity.check!
  end
end

