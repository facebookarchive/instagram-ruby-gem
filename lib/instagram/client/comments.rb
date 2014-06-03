module Instagram
  class Client
    # Defines methods related to comments
    module Comments
      # Returns a list of comments for a given media item ID
      #
      # @overload media_comments(id)
      #   @param id [Integer] An Instagram media item ID
      #   @return [Hashie::Mash] The requested comments.
      #   @example Returns a list of comments for the media item of ID 1234
      #     Instagram.media_comments(777)
      # @format :json
      # @authenticated true
      #
      #   If getting this data of a protected user, you must be authenticated (and be allowed to see that user).
      # @rate_limited true
      # @see http://instagram.com/developer/endpoints/comments/#get_media_comments
      def media_comments(id, *args)
        response = get("media/#{id}/comments")
        response
      end

      # Creates a comment for a given media item ID
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
      # @see http://instagram.com/developer/endpoints/comments/#post_media_comments
      def create_media_comment(id, text, options={})
        response = post("media/#{id}/comments", options.merge(:text => text), signature=true)
        response
      end

      # Deletes a comment for a given media item ID
      #
      # @overload delete_media_comment(media_id, comment_id)
      #   @param media_id [Integer] An Instagram media item ID.
      #   @param comment_id [Integer] Your comment ID of the comment you wish to delete.
      #   @return [nil]
      #   @example Delete the comment with ID of 1234, on the media item with ID of 777
      #     Instagram.delete_media_comment(777, 1234)
      # @format :json
      # @authenticated true
      #
      #   In order to remove a comment, you must be the owner of the comment, the media item, or both.
      # @rate_limited true
      # @see http://instagram.com/developer/endpoints/comments/#delete_media_comments
      def delete_media_comment(media_id, comment_id, options={})
        response = delete("media/#{media_id}/comments/#{comment_id}", options, signature=true)
        response
      end
    end
  end
end
