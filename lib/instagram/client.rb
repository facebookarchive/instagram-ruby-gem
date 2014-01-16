module Instagram
  # Wrapper for the Instagram REST API
  #
  # @note All methods have been separated into modules and follow the same grouping used in http://instagram.com/developer/
  # @see http://instagram.com/developer/
  class Client < API
    Dir[File.expand_path('../client/*.rb', __FILE__)].each{|f| require f}

    include Instagram::Client::Utils

    include Instagram::Client::Users
    include Instagram::Client::Media
    include Instagram::Client::Locations
    include Instagram::Client::Geographies
    include Instagram::Client::Tags
    include Instagram::Client::Comments
    include Instagram::Client::Likes
    include Instagram::Client::Subscriptions
    include Instagram::Client::Embedding
  end
end
