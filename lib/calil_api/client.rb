require 'uri'
require 'net/http'
require 'cgi'
require 'json'

module CalilApi
  class Client
    def initialize(endpoint, debug_mode = false)
      @url = URI.parse(endpoint)
      @debug_mode = debug_mode
      @format = 'json'
      @appkey = 'appkey'
    end

    def format
      @format
    end

    def appkey
      @appkey
    end

    def url
      @url
    end

    def debug_mode?
      @debug_mode == true
    end

    def get(params)
      params[:format] = format
      params[:appkey] = appkey
      response = request(url.path, params)
      JSON.parse(response.body)
    end

    private
    def request(path, params)
      http = Net::HTTP.new(@url.host, @url.port)
      http.use_ssl = true
      http.set_debug_output($stderr) if debug_mode?
      path = "#{path}?#{params.map { |k, v| "#{k}=#{CGI.escape(v.to_s)}" }.join('&')}"
      header = {
        'User-Agent' => "CalilApi v#{CalilApi::VERSION}(ruby-#{RUBY_VERSION} [#{RUBY_PLATFORM}])"
      }
      http.get(path, header)
    end
  end
end
