require 'faraday'

# @private
module Faraday
  # @private
  class Request::OAuth2 < Faraday::Middleware
    def call(env)

      params = {}

      if @access_token
        params[:access_token] = @access_token
        env[:request_headers].merge!('Authorization' => "Token token=\"#{@access_token}\"")
      elsif @client_id
        params[:client_id] = @client_id
      end

      if env[:body]
        env[:body] = env[:body].merge(params)
      elsif env[:url].query_values
        env[:url].query_values = env[:url].query_values.merge(params)
      else
        env[:url].query_values = params
      end

      @app.call env
    end

    def initialize(app, client_id, access_token=nil)
      @app = app
      @client_id = client_id
      @access_token = access_token
    end
  end
end
