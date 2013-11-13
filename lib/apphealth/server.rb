module AppHealth
  class Server
    attr_accessor :host, :message, :duration, :checked, :code

    def initialize(host)
      @host = host
      @checked = false
      @message = nil
      @code = nil
      @duration = nil
    end

    def unchecked?
      @checked == false
    end

    def check(uri)
      return self if checked

      benchmark = Benchmark.measure do
        request = make_request(uri)

        @code = request.code
        @message = request.message
      end

      @duration = (benchmark.real*1000).round
      @checked = true

      self
    end

    private
    def make_request(uri)
      Net::HTTP.start(host) do |http|
        uri.path = "/" if uri.path == ""
        request = Net::HTTP::Get.new(uri.path)
        request['Host'] = uri.host

        http.request(request)
      end
    end
  end
end
