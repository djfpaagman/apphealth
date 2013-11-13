require 'spec_helper'

describe AppHealth::Checker do
  before(:each) do
    AppHealth::Config.stub(:config_file).and_return do
      File.open(File.join('fixtures', 'domain.com.yml'), 'r')
    end
  end

  describe '.new' do
    context 'without argument' do
      it 'loads default url' do

        expect(AppHealth::Checker.new.uri).to eq URI.parse("http://domain.com/foo123")
      end
    end

    context 'with argument' do
      it 'loads that url' do
        domain = 'http://domain.com'

        expect(AppHealth::Checker.new(domain).uri).to eq URI.parse(domain)
      end
    end

    it 'sets up threads array' do
      expect(AppHealth::Checker.new.threads).to be_kind_of(Array)
    end

    it 'loads servers' do
      expect(AppHealth::Checker.new.servers.size).to eq 2

      AppHealth::Checker.new.servers.each do |server|
        expect(server).to be_kind_of AppHealth::Server
      end
    end
  end

  describe '#run' do
    context 'checks all servers' do
      FakeWeb.register_uri(:get, "http://server01.domain.com/foo123",
                            status: ["200", "OK"])
      FakeWeb.register_uri(:get, "http://server02.domain.com/foo123",
                            status: ["200", "OK"])

      it 'runs in threads' do
      checker = AppHealth::Checker.new.run
        expect(checker.threads.size).to eq 2
      end

      it 'checked the servers' do
        checker = AppHealth::Checker.new.run
        expect(checker.servers.map(&:checked)).to eq [true, true]
      end

      it 'is all fine' do
        checker = AppHealth::Checker.new.run
        expect(checker.servers.map(&:code)).to eq ['200', '200']
      end
    end
  end
end
