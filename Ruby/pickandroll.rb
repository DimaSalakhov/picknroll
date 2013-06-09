require 'json'
require 'hash_deep_merge'
#require 'awesome_print'

class PickAndRoll
  MASTER_CONFIG = 'config.json'
  PARCONFIG_FILE_NAME = '.parconfig'

	def initialize(config_path = '')
    @config_file = config_path.to_s
  end

  def pick
    if File.exist?(MASTER_CONFIG)
      @config = JSON.parse(File.read(MASTER_CONFIG))
      puts "pick config: #{MASTER_CONFIG}"
    else
      @config = Hash.new
    end

    if @config_file.strip.empty? == false && File.exists?("#{@config_file}.json")
      @config.deep_merge!(JSON.parse(File.read("#{@config_file}.json")))
      puts "pick config: #{@config_file}.json"
    elsif File.exist?("#{ENV["COMPUTERNAME"]}.json")
      @config.deep_merge!(JSON.parse(File.read("#{ENV["COMPUTERNAME"]}.json")))
      puts "pick config: #{ENV["COMPUTERNAME"]}.json"
    end

    if @config.empty?
      printf 'Please set configuration path or create config.json file'
      exit
    end
  end

  def roll
    file_patterns = read_file_patterns()

    file_patterns.each {|file_pattern|
      Dir.glob("**/#{file_pattern}"){ |file_name|
        File.open(file_name,'r'){ |config_file|
          puts "roll file: #{file_name}"
          File.open(file_name.gsub(/\.generic\./,'.'), 'w'){ |f|
            f.write config_file.read().gsub(/@@([\w\.]*)@@/) {|s| find_config_value $1}
          }
        }
      }
    }
  end

  def read_file_patterns
    file_patterns = Array.new
    if File.exist?(PARCONFIG_FILE_NAME)
      File.open(PARCONFIG_FILE_NAME, 'r').each { |line|
        file_patterns.push(line.strip)
      }
    end

    file_patterns
  end

  def find_config_value(key)
    key.split('.').inject(@config) { |config, name| config[name] }
  end

  def build
    pick
    roll
  end
end