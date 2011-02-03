module Instagram
  class Client
    # Defines methods related to comments
    module Comments
      # Returns a list of comments for a given media item ID
      #
      # @overload media_comments(id)
      #   @param id [Integer] An Instagram media item ID
      #   @return [Hashie::Mash] The requested comment.
      #   @example Returns a list of comments for the media item of ID 1234
      #     Instagram.media_comments(777)
      # @format :json
      # @authenticated true
      #
      #   If getting this data of a protected user, you must be authenticated (and be allowed to see that user).
      # @rate_limited true
      # @see TODO:docs url
      def media_comments(id, *args)
        response = get("media/#{id}/comments")
        response["data"]
      end
      
      # Create's a comment for a given media item ID
      #
      # @overload create_media_comment(id, text)
      #   @param id [Integer] An Instagram media item ID
      #   @param text [String] The text of your comment
      #   @return [Hashie::Mash] The comment created.
      #   @example Creates a new comment on media item with ID 777
      #     Instagram.create_media_comment(777, "Oh noes!")
      # @format :json
      # @authenticated true
      #
      #   If getting this data of a protected user, you must be authenticated (and be allowed to see that user).
      # @rate_limited true
      # @see TODO:docs url
      def create_media_comment(id, text, options={})
        response = post("media/#{id}/comments", options.merge(:text => text))
        response["data"]
      end
      
    end
  end
end
