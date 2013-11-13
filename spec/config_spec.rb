require 'spec_helper'

describe AppHealth::Config do
  config_file_com = File.open(File.join('fixtures', 'domain.com.yml'), 'r')
  config_file_net = File.open(File.join('fixtures', 'domain.net.yml'), 'r')
  config_com = YAML.load_file(config_file_com)

  context '.home_dir_file' do
    it 'returns the file when the it exists' do
      File.stub(:open).and_return(config_file_com)

      expect(AppHealth::Config.home_dir_file).to be_kind_of File
      expect(AppHealth::Config.home_dir_file).to eq config_file_com
    end

    it 'returns nil when it doesnt exist' do
      File.stub(:open).and_raise(Errno::ENOENT)

      expect(AppHealth::Config.home_dir_file).to eq nil
    end
  end

  context '.current_dir_file' do
    it 'returns the file when the it exists' do
      File.stub(:open).and_return(config_file_com)

      expect(AppHealth::Config.current_dir_file).to be_kind_of File
      expect(AppHealth::Config.current_dir_file).to eq config_file_com
    end

    it 'returns nil when it doesnt exist' do
      File.stub(:open).and_raise(Errno::ENOENT)

      expect(AppHealth::Config.current_dir_file).to eq nil
    end
  end

  context '.config_file' do
    before do
      AppHealth::Config.stub(:home_dir_file).and_return(config_file_net)
      AppHealth::Config.stub(:current_dir_file).and_return(config_file_com)
    end

    it 'prefers .current_dir_file over .home_dir_file' do
      expect(AppHealth::Config.config_file).to eq config_file_com
    end

    it 'uses .home_dir_file when .current_dir_file doesnt exist' do
      AppHealth::Config.stub(:current_dir_file).and_return(nil)

      expect(AppHealth::Config.config_file).to eq config_file_net
    end
  end

  context '.config' do
    it 'throws ConfigNotFound if no config file found' do
      AppHealth::Config.stub(:config_file).and_return(nil)

      expect { AppHealth::Config.config }.to raise_error(AppHealth::ConfigNotFound)
    end

    it 'parses yml config' do
      AppHealth::Config.stub(:config_file).and_return(config_file_com)

      expect(AppHealth::Config.config).to eq config_com
    end
  end

  context '.servers' do
    it 'returns servers from config file' do
      AppHealth::Config.stub(:config).and_return(config_com)

      expect(AppHealth::Config.servers).to eq ["server01.domain.com", "server02.domain.com"]
    end
  end

  context '.default_url' do
    it 'returns default url from config file' do
      AppHealth::Config.stub(:config).and_return(config_com)

      expect(AppHealth::Config.default_url).to eq 'http://domain.com/foo123'
    end
  end
end
