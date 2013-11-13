module AppHealth
  class Checker
    attr_accessor :uri, :threads, :servers

    def initialize(url = nil)
      url ||= Config.default_url

      @uri = URI.parse(url)
      @threads = []
      @servers = Config.servers.map do |server|
        Server.new(server)
      end
    end

    def run
      servers.select(&:unchecked?).each do |server|
        threads << Thread.new do
          server.check(uri)
        end
      end

      threads.each(&:join)

      self
    end
  end
end
