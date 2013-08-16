require 'json'
#require 'awesome_print'

class PickAndRoll
  CONFIGS_DIR = '_configs'
  MASTER_CONFIG = 'config.json'
  PARCONFIG_FILE_NAME = '.parconfig'

  def initialize(config_path = '')
    @parconfig = read_configuration
    @configs_dir = @parconfig.has_key?('customDir') ? @parconfig['customDir'] : CONFIGS_DIR
    @config_file = config_path.to_s
  end

  def pick
    master_config_path = File.join(@configs_dir, @parconfig.has_key?('config') ? @parconfig['config'] : MASTER_CONFIG)
    if File.size?(master_config_path) != nil
      @config = JSON.parse(File.read(master_config_path))
      puts "pick config: #{master_config_path}"
    else
      @config = Hash.new
    end

    custom_config_path = File.join(@configs_dir, "#{@config_file.strip.empty? ? ENV['COMPUTERNAME'] : @config_file}.json")
    if File.size?(custom_config_path) != nil
      @config.deep_merge!(JSON.parse(File.read(custom_config_path)))
      puts "pick config: #{custom_config_path}"
    end

    if @config.empty?
      printf 'Please set configuration path or create config.json file'
      exit
    end
  end

  def roll
    file_patterns = get_file_patterns()

    file_patterns.each {|file_pattern|
      Dir.glob("**/#{file_pattern}"){ |file_name|
        File.open(file_name,'r'){ |rolling_file|
          puts "roll file: #{file_name}"
          content = rolling_file.read()
          File.open(file_name.gsub(/\.generic\./,'.'), 'w'){ |f|
            f.write content.gsub(/@@([\w\.]*)@@/) {|s| find_config_value $1}
          }
        }
      }
    }
  end

  def get_file_patterns
    @parconfig.has_key?('files') ? @parconfig['files'] : Array.new
  end

  def read_configuration
    result = Hash.new
    if File.exist?(PARCONFIG_FILE_NAME)
      result = JSON.parse(File.read(PARCONFIG_FILE_NAME))
    end

    result
  end

  def find_config_value(key)
    result = key.split('.').inject(@config) { |config, name| config.nil? ? nil : config[name] }
    if result.nil?
      puts "ERROR: cannot find value for parameter #{key}"
    end
    result
  end

  def go
    pick
    roll
  end
end

class Hash

  def deep_merge!(specialized_hash)
    return internal_deep_merge!(self, specialized_hash)
  end

  def deep_merge(specialized_hash)
    return internal_deep_merge!(Hash.new.replace(self), specialized_hash)
  end

  protected
    def internal_deep_merge!(source_hash, specialized_hash)
      specialized_hash.each_pair do |rkey, rval|
        if source_hash.has_key?(rkey) then
          if rval.is_a?(Hash) and source_hash[rkey].is_a?(Hash) then
            internal_deep_merge!(source_hash[rkey], rval)
          elsif rval == source_hash[rkey] then
          else
            source_hash[rkey] = rval
          end
        else
          source_hash[rkey] = rval
        end
      end
      return source_hash
    end
end