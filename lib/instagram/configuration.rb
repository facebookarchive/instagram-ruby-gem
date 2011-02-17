require 'faraday'
require File.expand_path('../version', __FILE__)

module Instagram
  # Defines constants and methods related to configuration
  module Configuration
    # An array of valid keys in the options hash when configuring a {Instagram::API}
    VALID_OPTIONS_KEYS = [
      :adapter,
      :client_id,
      :client_secret,
      :access_token,
      :endpoint,
      :format,
      :user_agent,
      :proxy
    ].freeze

    # An array of valid request/response formats
    #
    # @note Not all methods support the XML format.
    VALID_FORMATS = [
      :json].freeze

    # The adapter that will be used to connect if none is set
    #
    # @note The default faraday adapter is Net::HTTP.
    DEFAULT_ADAPTER = Faraday.default_adapter

    # By default, don't set an application ID
    DEFAULT_CLIENT_ID = nil

    # By default, don't set an application secret
    DEFAULT_CLIENT_SECRET = nil

    # By default, don't set an application redirect uri
    DEFAULT_REDIRECT_URI = nil

    # By default, don't set a user access token
    DEFAULT_ACCESS_TOKEN = nil

    # The endpoint that will be used to connect if none is set
    #
    # @note There is no reason to use any other endpoint at this time
    DEFAULT_ENDPOINT = 'https://api.instagram.com/v1/'.freeze

    # The response format appended to the path and sent in the 'Accept' header if none is set
    #
    # @note JSON is the only available format at this time
    DEFAULT_FORMAT = :json

    # By default, don't use a proxy server
    DEFAULT_PROXY = nil

    # The user agent that will be sent to the API endpoint if none is set
    DEFAULT_USER_AGENT = "Instagram Ruby Gem #{Instagram::VERSION}".freeze

    # @private
    attr_accessor *VALID_OPTIONS_KEYS

    # When this module is extended, set all configuration options to their default values
    def self.extended(base)
      base.reset
    end

    # Convenience method to allow configuration options to be set in a block
    def configure
      yield self
    end

    # Create a hash of options and their values
    def options
      VALID_OPTIONS_KEYS.inject({}) do |option, key|
        option.merge!(key => send(key))
      end
    end

    # Reset all configuration options to defaults
    def reset
      self.adapter        = DEFAULT_ADAPTER
      self.client_id      = DEFAULT_CLIENT_ID
      self.client_secret  = DEFAULT_CLIENT_SECRET
      self.access_token   = DEFAULT_ACCESS_TOKEN
      self.endpoint       = DEFAULT_ENDPOINT
      self.format         = DEFAULT_FORMAT
      self.user_agent     = DEFAULT_USER_AGENT
      self.proxy          = DEFAULT_PROXY
    end
  end
end