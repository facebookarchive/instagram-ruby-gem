module Instagram
  # Wrapper for the Instagram REST API
  #
  # @note All methods have been separated into modules and follow the same grouping used in {TODO:doc_URL the Instagram API Documentation}.
  # @see TODO:doc_url
  class Client < API
    Dir[File.expand_path('../client/*.rb', __FILE__)].each{|f| require f}
    
    include Instagram::Client::Utils
    
    include Instagram::Client::User
    include Instagram::Client::Media
    include Instagram::Client::Location
    include Instagram::Client::Tag
  end
end