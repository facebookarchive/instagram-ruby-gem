require 'faraday'

# @private
module FaradayMiddleware
  # @private
  class OAuth2 < Faraday::Middleware
    def call(env)
      if env[:method] == :get or env[:method] == :delete
        query = Faraday::Utils.parse_query(env[:url].query)

        if @access_token and not query["client_secret"]
          query.update(:access_token => @access_token)
          env[:request_headers] = env[:request_headers].merge('Authorization' => "Token token=\"#{@access_token}\"")
        elsif @client_id
          query.update(:client_id => @client_id)
        end
        env[:url].query = Faraday::Utils.build_query(query)
      else
        if @access_token and not env[:body] && env[:body][:client_secret]
          env[:body] = {} if env[:body].nil?
          env[:body] = env[:body].merge(:access_token => @access_token)
          env[:request_headers] = env[:request_headers].merge('Authorization' => "Token token=\"#{@access_token}\"")
        elsif @client_id
          env[:body] = env[:body].merge(:client_id => @client_id)
        end
      end

      env[:url].query = nil if env[:url].query == ""

      @app.call env
    end

    def initialize(app, client_id, access_token=nil)
      @app = app
      @client_id = client_id
      @access_token = access_token
    end
  end
end
