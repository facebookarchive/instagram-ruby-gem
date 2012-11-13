require 'faraday'

# @private
module FaradayMiddleware
  # @private
  class InstagramOAuth2 < Faraday::Middleware
    def call(env)

      if env[:method] == :get or env[:method] == :delete
        if env[:url].query.nil?
          query = {}
        else
          query = Faraday::Utils.parse_query(env[:url].query)
        end

        if @access_token and not query["client_secret"]
          env[:url].query = Faraday::Utils.build_query(query.merge(:access_token => @access_token))
          env[:request_headers] = env[:request_headers].merge('Authorization' => "Token token=\"#{@access_token}\"")
        elsif @client_id
          env[:url].query = Faraday::Utils.build_query(query.merge(:client_id => @client_id))
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
