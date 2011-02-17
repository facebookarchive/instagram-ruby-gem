require 'faraday'

# @private
module Faraday
  # @private
  class Request::OAuth2 < Faraday::Middleware
    def call(env)

      if env[:method] == :get or env[:method] == :delete
        env[:url].query_values = {} if env[:url].query_values.nil?
        if @access_token and not env[:url].query_values["client_secret"]
          env[:url].query_values = env[:url].query_values.merge(:access_token => @access_token)
          env[:request_headers] = env[:request_headers].merge('Authorization' => "Token token=\"#{@access_token}\"")
        elsif @client_id
          env[:url].query_values = env[:url].query_values.merge(:client_id => @client_id)
        end
      else
        if @access_token and not env[:body] && env[:body][:client_secret]
          env[:body] = {} if env[:body].nil?
          env[:body] = env[:body].merge(:access_token => @access_token)
          env[:request_headers] = env[:request_headers].merge('Authorization' => "Token token=\"#{@access_token}\"")
        elsif @client_id
          env[:body] = env[:body].merge(:client_id => @client_id)
        end
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
