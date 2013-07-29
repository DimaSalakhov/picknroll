desc "launch pick and roll"
task :pickandroll => :environment do
  require 'pickandroll'

  custom_config = ENV['CUSTOM_CONFIG'].to_s
  PickAndRoll.new(custom_config).go
end
