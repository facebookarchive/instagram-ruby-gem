module Instagram
  class Client
    # Defines methods related to media items
    module Media
      # Returns extended information of a given media item
      #
      # @overload media_item(id=nil, options={})
      #   @param user [Integer] An Instagram media item ID
      #   @return [Hashie::Mash] The requested media item.
      #   @example Return extended information for media item 1234
      #     Instagram.media_item(1324)
      # @format :json
      # @authenticated false unless requesting media from a protected user
      #
      #   If getting this data of a protected user, you must authenticate (and be allowed to see that user).
      # @rate_limited true
      # @see TODO:docs url
      def media_item(*args)
        id = args.first || 'self'
        response = get("media/#{id}")
        response['data']
      end
      
      # Returns a list of the overall most popular media
      #
      # @overload media_popular(options={})
      #   @param options [Hash] A customizable set of options.
      #   @return [Hashie::Mash]
      #   @example Returns a list of the overall most popular media
      #     Instagram.media_popular
      # @see TODO:docs url
      # @format :json
      # @authenticated false unless requesting it from a protected user
      #
      #   If getting this data of a protected user, you must authenticate (and be allowed to see that user).
      # @rate_limited true
      def media_popular(*args)
        options = args.last.is_a?(Hash) ? args.pop : {}
        id = args.first || "self"
        response = get("media/popular", options)
        response["data"]
      end
      
      # Returns media items within proximity of given lat,lng
      #
      # @format :json
      # @authenticated false
      # @rate_limited true
      # @param latlng [String] A comma separated string containing a latitude and longitude of which to center the search.
      # @param options [Hash] A customizable set of options.
      # @option options [Integer] :count The number of media items to retrieve. Maxiumum of 100 allowed per page.
      # @return [Array]
      # @see TODO:doc url
      # @example Return media around "37.7808851,-122.3948632" (164 S Park, SF, CA USA)
      #   Instagram.media_search('37.7808851,-122.3948632')
      def media_search(latlng, options={})
        response = get('media/search', options.merge(:ll => latlng))
        response['data']
      end
    end
  end
end