require_relative 'instagram/error'
require_relative 'instagram/configuration'
require_relative 'instagram/api'
require_relative 'instagram/client'
require_relative 'instagram/response'

module Instagram
  extend Configuration

  # Alias for Instagram::Client.new
  #
  # @return [Instagram::Client]
  def self.client(options={})
    Instagram::Client.new(options)
  end

  # Delegate to Instagram::Client
  def self.method_missing(method, *args, &block)
    return super unless client.respond_to?(method)
    client.send(method, *args, &block)
  end

  # Delegate to Instagram::Client
  def self.respond_to?(method, include_all=false)
    return client.respond_to?(method, include_all) || super
  end
end
