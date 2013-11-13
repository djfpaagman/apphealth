require 'spec_helper'

describe AppHealth::Server do
  describe '.new' do
    it 'requires a host' do
      expect { AppHealth::Server.new }.to raise_error
    end
  end

  describe '#unchecked?' do
    server = AppHealth::Server.new('foo.bar.com')

    it 'is true if checked if false' do
      expect(server.unchecked?).to eq true
    end

    it 'is false if checked is true' do
      server.checked = true

      expect(server.unchecked?).to eq false
    end
  end

  describe '#check' do
    it 'requires an uri' do
      expect { AppHealth::Server.new('foo.bar.com').check }.to raise_error
    end

    context 'with valid uri' do
      context 'and 200 response' do
        FakeWeb.register_uri(:get, "http://server01.domain.com/im_fine",
                             status: ["200", "OK"])

        uri = URI.parse('http://domain.com/im_fine')
        request = AppHealth::Server.new('server01.domain.com').check(uri)

        it 'sets checked' do
          expect(request.checked).to eq true
        end

        it 'times request' do
          expect(request.duration).not_to eq nil
        end

        it 'sets message' do
          expect(request.message).to eq 'OK'
        end

        it 'sets code' do
          expect(request.code).to eq '200'
        end
      end
    end

    context 'and 404 response' do
      FakeWeb.register_uri(:get, "http://server01.domain.com/non_existing",
                            status: ["404", "Not Found"])

      uri = URI.parse('http://domain.com/non_existing')
      request = AppHealth::Server.new('server01.domain.com').check(uri)

      it 'sets message' do
        expect(request.message).to eq 'Not Found'
      end

      it 'sets code' do
        expect(request.code).to eq '404'
      end
    end

    context 'and 500 response' do
      FakeWeb.register_uri(:get, "http://server01.domain.com/error",
                            status: ["500", "Internal Server Error"])

      uri = URI.parse('http://domain.com/error')
      request = AppHealth::Server.new('server01.domain.com').check(uri)

      it 'sets message' do
        expect(request.message).to eq 'Internal Server Error'
      end

      it 'sets code' do
        expect(request.code).to eq '500'
      end
    end
  end
end
