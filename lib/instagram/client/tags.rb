module Instagram
  class Client
    # Defines methods related to tags
    module Tags
      # Returns extended information of a given Instagram tag
      #
      # @overload tag(tag)
      #   @param tag [String] An Instagram tag name
      #   @return [Hashie::Mash] The requested tag.
      #   @example Return extended information for the tag "cat"
      #     Instagram.tag('cat')
      # @format :json
      # @authenticated false
      # @rate_limited true
      # @see TODO:docs url
      def tag(tag, *args)
        response = get("tags/#{tag}")
        response["data"]
      end

      # Returns a list of recent media items for a given Instagram tag
      #
      # @overload tag_recent_media(tag, options={})
      #   @param user [String] An Instagram tag name.
      #   @param options [Hash] A customizable set of options.
      #   @option options [Integer] :max_id (nil) Returns results with an ID less than (that is, older than) or equal to the specified ID.
      #   @option options [Integer] :count (nil) Limits the number of results returned per page.
      #   @return [Hashie::Mash]
      #   @example Return a list of the most recent media items tagged "cat"
      #     Instagram.tag_recent_media('cat')
      # @see TODO:docs url
      # @format :json
      # @authenticated false
      # @rate_limited true
      def tag_recent_media(id, *args)
        options = args.last.is_a?(Hash) ? args.pop : {}
        response = get("tags/#{id}/media/recent", options)
        response
      end

      # Returns a list of tags starting with the given search query
      #
      # @format :json
      # @authenticated false
      # @rate_limited true
      # @param query [String] The beginning or complete tag name to search for
      # @param options [Hash] A customizable set of options.
      # @option options [Integer] :count The number of media items to retrieve.
      # @return [Array]
      # @see TODO:doc url
      # @example Return tags that start with "cat"
      #   Instagram.tag_search("cat")
      def tag_search(query, options={})
        response = get('tags/search', options.merge(:q => query))
        response["data"]
      end
    end
  end
end
