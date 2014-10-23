module Instagram
  class Client
    # Defines methods related to media items
    module Media
      # Returns extended information of a given media item
      #
      # @overload media_item(id)
      #   @param user [Integer] An Instagram media item ID
      #   @return [Hashie::Mash] The requested media item.
      #   @example Return extended information for media item 1234
      #     Instagram.media_item(1324)
      # @format :json
      # @authenticated false unless requesting media from a protected user
      #
      #   If getting this data of a protected user, you must authenticate (and be allowed to see that user).
      # @rate_limited true
      # @see http://instagram.com/developer/endpoints/media/#get_media
      def media_item(*args)
        id = args.first || 'self'
        response = get("media/#{id}")
        response
      end

      # Returns extended information of a given media item
      #
      # @overload media_shortcode(shortcode)
      #   @param shortcode [String] An Instagram media item shortcode
      #   @return [Hashie::Mash] The requested media item.
      #   @example Return extended information for media item with shortcode 'D'
      #     Instagram.media_shortcode('D')
      # @format none
      # @authenticated false unless requesting media from a protected user
      #
      #   If getting this data of a protected user, you must authenticate (and be allowed to see that user).
      # @rate_limited true
      # @see http://instagram.com/developer/endpoints/media/#get_media_by_shortcode
      def media_shortcode(*args)
        shortcode = args.first
        response = get("media/shortcode/#{shortcode}", {}, false, false, true)
        response
      end

      # Returns a list of the overall most popular media
      #
      # @overload media_popular(options={})
      #   @param options [Hash] A customizable set of options.
      #   @return [Hashie::Mash]
      #   @example Returns a list of the overall most popular media
      #     Instagram.media_popular
      # @see http://instagram.com/developer/endpoints/media/#get_media_popular
      # @format :json
      # @authenticated false unless requesting it from a protected user
      #
      #   If getting this data of a protected user, you must authenticate (and be allowed to see that user).
      # @rate_limited true
      def media_popular(*args)
        options = args.last.is_a?(Hash) ? args.pop : {}
        id = args.first || "self"
        response = get("media/popular", options)
        response
      end

      # Returns media items within proximity of given lat,lng
      #
      # @param lat [String] A given latitude in decimal format
      # @param lng [String] A given longitude in decimal format
      # @param options [Hash] A customizable set of options.
      # @option options [Integer] :count The number of media items to retrieve.
      # @return [Hashie::Mash] A list of matching media
      # @example Return media around 37.7808851, -122.3948632 (164 S Park, SF, CA USA)
      #   Instagram.media_search("37.7808851", "-122.3948632")
      # @see http://instagram.com/developer/endpoints/media/#get_media_search
      # @format :json
      # @authenticated false
      # @rate_limited true
      def media_search(lat, lng, options={})
        response = get('media/search', options.merge(:lat => lat, :lng => lng))
        response
      end
    end
  end
end
