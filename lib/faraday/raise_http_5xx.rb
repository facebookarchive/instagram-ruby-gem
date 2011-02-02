require 'faraday'

# @private
module Faraday
  # @private
  class Response::RaiseHttp5xx < Response::Middleware
    def self.register_on_complete(env)
      env[:response].on_complete do |response|
        case response[:status].to_i
        when 500
          raise Instagram::InternalServerError, error_message(response, "Something is technically wrong.")
        when 503
          raise Instagram::ServiceUnavailable, error_message(response, "Instagram is rate limiting your requests.")
        end
      end
    end

    def initialize(app)
      super
      @parser = nil
    end

    private

    def self.error_message(response, body=nil)
      "#{response[:method].to_s.upcase} #{response[:url].to_s}: #{[response[:status].to_s + ':', body].compact.join(' ')}"
    end
  end
end
