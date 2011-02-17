module Instagram
  class Client
    # Defines methods related to likes
    module Likes
      # Returns a list of users who like a given media item ID
      #
      # @overload media_likes(id)
      #   @param media [Integer] An Instagram media item ID
      #   @return [Hashie::Mash] A list of users.
      #   @example Returns a list of users who like the media item of ID 1234
      #     Instagram.media_likes(777)
      # @format :json
      # @authenticated true
      #
      #   If getting this data of a protected user, you must be authenticated (and be allowed to see that user).
      # @rate_limited true
      # @see TODO:docs url
      def media_likes(id, *args)
        response = get("media/#{id}/likes")
        response["data"]
      end

      # Issues a like by the currently authenticated user, for a given media item ID
      #
      # @overload like_media(id, text)
      #   @param id [Integer] An Instagram media item ID
      #   @return [nil]
      #   @example Like media item with ID 777
      #     Instagram.like_media(777)
      # @format :json
      # @authenticated true
      #
      #   If getting this data of a protected user, you must be authenticated (and be allowed to see that user).
      # @rate_limited true
      # @see TODO:docs url
      def like_media(id, options={})
        response = post("media/#{id}/likes", options)
        response["data"]
      end

      # Removes the like on a givem media item ID for the currently authenticated user
      #
      # @overload unlike_media(id)
      #   @param media_id [Integer] An Instagram media item ID.
      #   @return [nil]
      #   @example Remove the like for the currently authenticated user on the media item with the ID of 777
      #     Instagram.unlike_media(777)
      # @format :json
      # @authenticated true
      # @rate_limited true
      # @see TODO:docs url
      def unlike_media(id, options={})
        response = delete("media/#{id}/likes", options)
        response["data"]
      end
    end
  end
end
