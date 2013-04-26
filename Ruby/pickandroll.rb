require 'json'

class PickAndRoll
	def initialize(config_path = 'config.json')
    @config_file = config_path
  end

  def pick
    if File.exists?(@config_file) == false
      printf 'Please set configuration path or create config.json file'
      return
    end
    @config = JSON.parse(IO.read(@config_file))
  end

  def roll
    file_names = ['config.generic.xml']

    file_names.each do |file_name|
      File.open(file_name,"r"){ |generic_config|
        File.open(file_name.gsub(/\.generic\./,'.'), "w"){ |f|
          f.write generic_config.read().gsub(/@@([\w\.]*)@@/) {|s| find_config_value $1}
        }
      }
    end
  end

  def find_config_value(key)
    key.split('.').inject(@config) { |config, key| config[key] }
  end

  def build
    pick
    roll
  end
end