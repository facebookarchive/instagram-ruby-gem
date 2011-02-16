require 'faraday'

# @private
module Faraday
  # @private
  class Request::OAuth2 < Faraday::Middleware
    def call(env)
      params = env[:url].query_values || {}

      if @access_token
        params.merge!('access_token' => @access_token)
        env[:request_headers].merge!('Authorization' => "Token token=\"#{@access_token}\"")
      elsif @client_id
        params.merge!('client_id' => @client_id)
      end

      env[:url].query_values = params unless params == {}

      @app.call env
    end

    def initialize(app, client_id, access_token=nil)
      @app = app
      @client_id = client_id
      @access_token = access_token
    end
  end
end
