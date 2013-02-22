module Instagram
  class Client
    # Defines methods related to real-time geographies
    module Geographies
      # Returns a list of recent media items for a given real-time geography
      #
      # @overload geography_recent_media(id, options={})
      #   @param user [Integer] A geography ID from a real-time subscription.
      #   @param options [Hash] A customizable set of options.
      #   @option options [Integer] :count (nil) Limit the number of results returned
      #   @option options [Integer] :min_id (nil) Return media before this min_id
      #   @option options [Integer] :max_id (nil) Return media after this max_id
      #   @option options [Integer] :min_timestamp (nil) Return media after this UNIX timestamp
      #   @option options [Integer] :max_timestamp (nil) Return media before this UNIX timestamp
      #   @return [Hashie::Mash]
      #   @example Return a list of the most recent media items taken within a specific geography
      #     Instagram.geography_recent_media(514276)
      # @see http://instagram.com/developer/endpoints/geographies/
      # @format :json
      # @authenticated false
      # @rate_limited true
      def geography_recent_media(id, *args)
        options = args.last.is_a?(Hash) ? args.pop : {}
        response = get("geographies/#{id}/media/recent", options)
        response
      end
    end
  end
end
