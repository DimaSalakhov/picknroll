require 'json'
require 'hash_deep_merge'
#require 'awesome_print'

class PickAndRoll
  MASTER_CONFIG = 'config.json'

	def initialize(config_path = '')
    @config_file = config_path.to_s
  end

  def pick
    @config = File.exist?(MASTER_CONFIG) ? JSON.parse(File.read(MASTER_CONFIG)) : Hash.new

    if File.exists?("#{@config_file}.json")
      @config.deep_merge!(JSON.parse(File.read("#{@config_file}.json")))
    end

    if @config.empty?
      printf 'Please set configuration path or create config.json file'
      exit
    end
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

class Hash
  def can_recursively_merge? other
    Hash === other
  end

  def recursive_merge! other
    other.each do |key, value|
      if self.include? key and self[key].can_recursively_merge? value
        self[key].recursive_merge! value
      else
        self[key] = value
      end
    end
    self
  end
end