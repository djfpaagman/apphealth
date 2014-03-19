require 'yaml'

module AppHealth
  class ConfigNotFound < Exception; end

  class Config
    FILE_NAME = '.apphealth.yml'

    def self.servers
      self.config['servers']
    end

    def self.default_url
      self.config['default_url']
    end

    def self.config_file
      self.current_dir_file || self.home_dir_file
    end

    def self.config
      raise ConfigNotFound, 'Config file not found' unless self.config_file

      @config ||= YAML.load_file(self.config_file)
    end

    def self.home_dir_file
      File.open(File.join(Dir.home, FILE_NAME), 'r')
    rescue Errno::ENOENT
      nil
    end

    def self.current_dir_file
      File.open(File.join(Dir.pwd, FILE_NAME), 'r')
    rescue Errno::ENOENT
      nil
    end
  end
end
