require 'pick_and_roll'

puts 'Producing configs...'

PickAndRoll.new('custom_configuration').go #will execute with custom_configuration.json file as custom config. Could be used for test purposes or build servers
#PickAndRoll.new().go #will look for <machine-name>.json file as custom config