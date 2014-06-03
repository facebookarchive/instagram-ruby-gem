module Instagram
  class Client
    # Defines methods related to users
    module Users
      # Returns extended information of a given user
      #
      # @overload user(id=nil, options={})
      #   @param user [Integer] An Instagram user ID
      #   @return [Hashie::Mash] The requested user.
      #   @example Return extended information for @shayne
      #     Instagram.user(20)
      # @format :json
      # @authenticated false unless requesting it from a protected user
      #
      #   If getting this data of a protected user, you must authenticate (and be allowed to see that user).
      # @rate_limited true
      # @see http://instagram.com/developer/endpoints/users/#get_users
      def user(*args)
        options = args.last.is_a?(Hash) ? args.pop : {}
        id = args.first || 'self'
        response = get("users/#{id}", options)
        response
      end

      # Returns users that match the given query
      #
      # @format :json
      # @authenticated false
      # @rate_limited true
      # @param query [String] The search query to run against user search.
      # @param options [Hash] A customizable set of options.
      # @option options [Integer] :count The number of users to retrieve.
      # @return [Hashie::Mash]
      # @see http://instagram.com/developer/endpoints/users/#get_users_search
      # @example Return users that match "Shayne Sweeney"
      #   Instagram.user_search("Shayne Sweeney")
      def user_search(query, options={})
        response = get('users/search', options.merge(:q => query))
        response
      end

      # Returns a list of users whom a given user follows
      #
      # @overload user_follows(id=nil, options={})
      #   @param options [Hash] A customizable set of options.
      #   @return [Hashie::Mash]
      #   @example Returns a list of users the authenticated user follows
      #     Instagram.user_follows
      # @overload user_follows(id=nil, options={})
      #   @param user [Integer] An Instagram user ID.
      #   @param options [Hash] A customizable set of options.
      #   @option options [Integer] :cursor (nil) Breaks the results into pages. Provide values as returned in the response objects's next_cursor attribute to page forward in the list.
      #   @option options [Integer] :count (nil) Limits the number of results returned per page.
      #   @return [Hashie::Mash]
      #   @example Return a list of users @mikeyk follows
      #     Instagram.user_follows(4) # @mikeyk user ID being 4
      # @see http://instagram.com/developer/endpoints/relationships/#get_users_follows
      # @format :json
      # @authenticated false unless requesting it from a protected user
      #
      #   If getting this data of a protected user, you must authenticate (and be allowed to see that user).
      # @rate_limited true
      def user_follows(*args)
        options = args.last.is_a?(Hash) ? args.pop : {}
        id = args.first || "self"
        response = get("users/#{id}/follows", options)
        response
      end
    end

    # Returns a list of users whom a given user is followed by
    #
    # @overload user_followed_by(id=nil, options={})
    #   @param options [Hash] A customizable set of options.
    #   @return [Hashie::Mash]
    #   @example Returns a list of users the authenticated user is followed by
    #     Instagram.user_followed_by
    # @overload user_followed_by(id=nil, options={})
    #   @param user [Integer] An Instagram user ID.
    #   @param options [Hash] A customizable set of options.
    #   @option options [Integer] :cursor (nil) Breaks the results into pages. Provide values as returned in the response objects's next_cursor attribute to page forward in the list.
    #   @option options [Integer] :count (nil) Limits the number of results returned per page.
    #   @return [Hashie::Mash]
    #   @example Return a list of users @mikeyk is followed by
    #     Instagram.user_followed_by(4) # @mikeyk user ID being 4
    # @see http://instagram.com/developer/endpoints/relationships/#get_users_followed_by
    # @format :json
    # @authenticated false unless requesting it from a protected user
    #
    #   If getting this data of a protected user, you must authenticate (and be allowed to see that user).
    # @rate_limited true
    def user_followed_by(*args)
      options = args.last.is_a?(Hash) ? args.pop : {}
      id = args.first || "self"
      response = get("users/#{id}/followed-by", options)
      response
    end

    # Returns a list of users who have requested the currently authorized user's permission to follow
    #
    # @overload user_requested_by()
    #   @param options [Hash] A customizable set of options.
    #   @return [Hashie::Mash]
    #   @example Returns a list of users awaiting approval of a ollow request, for the authenticated user
    #     Instagram.user_requested_by
    # @overload user_requested_by()
    #   @return [Hashie::Mash]
    #   @example Return a list of users who have requested to follow the authenticated user
    #     Instagram.user_requested_by()
    # @see http://instagram.com/developer/endpoints/relationships/#get_incoming_requests
    # @format :json
    # @authenticated true
    # @rate_limited true
    def user_requested_by()
      response = get("users/self/requested-by")
      response
    end

    # Returns most recent media items from the currently authorized user's feed
    #
    # @overload user_media_feed(options={})
    #   @param options [Hash] A customizable set of options.
    #   @option options [Integer] :max_id Returns results with an ID less than (that is, older than) or equal to the specified ID.
    #   @option options [Integer] :min_id Return media later than this min_id
    #   @option options [Integer] :count Specifies the number of records to retrieve, per page.
    #   @return [Hashie::Mash]
    #   @example Return most recent media images that would appear on @shayne's feed
    #     Instagram.user_media_feed() # assuming @shayne is the authorized user
    # @format :json
    # @authenticated true
    # @rate_limited true
    # @see http://instagram.com/developer/endpoints/users/#get_users_feed
    def user_media_feed(*args)
      options = args.first.is_a?(Hash) ? args.pop : {}
      response = get('users/self/feed', options)
      response
    end

    # Returns a list of recent media items for a given user
    #
    # @overload user_recent_media(options={})
    #   @param options [Hash] A customizable set of options.
    #   @return [Hashie::Mash]
    #   @example Returns a list of recent media items for the currently authenticated user
    #     Instagram.user_recent_media
    # @overload user_recent_media(id=nil, options={})
    #   @param user [Integer] An Instagram user ID.
    #   @param options [Hash] A customizable set of options.
    #   @option options [Integer] :max_id (nil) Returns results with an ID less than (that is, older than) or equal to the specified ID.
    #   @option options [Integer] :count (nil) Limits the number of results returned per page.
    #   @return [Hashie::Mash]
    #   @example Return a list of media items taken by @mikeyk
    #     Instagram.user_recent_media(4) # @mikeyk user ID being 4
    # @see http://instagram.com/developer/endpoints/users/#get_users_media_recent
    # @format :json
    # @authenticated false unless requesting it from a protected user
    #
    #   If getting this data of a protected user, you must authenticate (and be allowed to see that user).
    # @rate_limited true
    def user_recent_media(*args)
      options = args.last.is_a?(Hash) ? args.pop : {}
      id = args.first || "self"
      response = get("users/#{id}/media/recent", options)
      response
    end

    # Returns a list of media items liked by the current user
    #
    # @overload user_liked_media(options={})
    #   @param options [Hash] A customizable set of options.
    #   @option options [Integer] :max_like_id (nil) Returns results with an ID less than (that is, older than) or equal to the specified ID.
    #   @option options [Integer] :count (nil) Limits the number of results returned per page.
    #   @return [Hashie::Mash]
    #   @example Returns a list of media items liked by the currently authenticated user
    #     Instagram.user_liked_media
    # @see http://instagram.com/developer/endpoints/users/#get_users_liked_feed
    # @format :json
    # @authenticated true
    # @rate_limited true
    def user_liked_media(options={})
      response = get("users/self/media/liked", options)
      response
    end

    # Returns information about the current user's relationship (follow/following/etc) to another user
    #
    # @overload user_relationship(id, options={})
    #   @param user [Integer] An Instagram user ID.
    #   @param options [Hash] An optional options hash
    #   @return [Hashie::Mash]
    #   @example Return the relationship status between the currently authenticated user and @mikeyk
    #     Instagram.user_relationship(4) # @mikeyk user ID being 4
    # @see http://instagram.com/developer/endpoints/relationships/#get_relationship
    # @format :json
    # @authenticated true
    # @rate_limited true
    def user_relationship(id, options={})
      response = get("users/#{id}/relationship", options)
      response
    end

    # Create a follows relationship between the current user and the target user
    #
    # @overload follow_user(id, options={})
    #   @param user [Integer] An Instagram user ID.
    #   @param options [Hash] An optional options hash
    #   @return [Hashie::Mash]
    #   @example Request the current user to follow the target user
    #     Instagram.follow_user(4)
    # @see http://instagram.com/developer/endpoints/relationships/#post_relationship
    # @format :json
    # @authenticated true
    # @rate_limited true
    def follow_user(id, options={})
      options["action"] = "follow"
      response = post("users/#{id}/relationship", options, signature=true)
      response
    end

    # Destroy a follows relationship between the current user and the target user
    #
    # @overload unfollow_user(id, options={})
    #   @param user [Integer] An Instagram user ID.
    #   @param options [Hash] An optional options hash
    #   @return [Hashie::Mash]
    #   @example Remove a follows relationship between the current user and the target user
    #     Instagram.unfollow_user(4)
    # @see http://instagram.com/developer/endpoints/relationships/#post_relationship
    # @format :json
    # @authenticated true
    # @rate_limited true
    def unfollow_user(id, options={})
      options["action"] = "unfollow"
      response = post("users/#{id}/relationship", options, signature=true)
      response
    end

    # Block a relationship between the current user and the target user
    #
    # @overload unfollow_user(id, options={})
    #   @param user [Integer] An Instagram user ID.
    #   @param options [Hash] An optional options hash
    #   @return [Hashie::Mash]
    #   @example Block a relationship between the current user and the target user
    #     Instagram.block_user(4)
    # @see http://instagram.com/developer/endpoints/relationships/#post_relationship
    # @format :json
    # @authenticated true
    # @rate_limited true
    def block_user(id, options={})
      options["action"] = "block"
      response = post("users/#{id}/relationship", options, signature=true)
      response
    end

    # Remove a relationship block between the current user and the target user
    #
    # @overload unblock_user(id, options={})
    #   @param user [Integer] An Instagram user ID.
    #   @param options [Hash] An optional options hash
    #   @return [Hashie::Mash]
    #   @example Remove a relationship block between the current user and the target user
    #     Instagram.unblock_user(4)
    # @see http://instagram.com/developer/endpoints/relationships/#post_relationship
    # @format :json
    # @authenticated true
    # @rate_limited true
    def unblock_user(id, options={})
      options["action"] = "unblock"
      response = post("users/#{id}/relationship", options, signature=true)
      response
    end

    # Approve a relationship request between the current user and the target user
    #
    # @overload approve_user(id, options={})
    #   @param user [Integer] An Instagram user ID.
    #   @param options [Hash] An optional options hash
    #   @return [Hashie::Mash]
    #   @example Approve a relationship request between the current user and the target user
    #     Instagram.approve_user(4)
    # @see http://instagram.com/developer/endpoints/relationships/#post_relationship
    # @format :json
    # @authenticated true
    # @rate_limited true
    def approve_user(id, options={})
      options["action"] = "approve"
      response = post("users/#{id}/relationship", options, signature=true)
      response
    end

    # Deny a relationship request between the current user and the target user
    #
    # @overload deny_user(id, options={})
    #   @param user [Integer] An Instagram user ID.
    #   @param options [Hash] An optional options hash
    #   @return [Hashie::Mash]
    #   @example Deny a relationship request between the current user and the target user
    #     Instagram.deny_user(4)
    # @see http://instagram.com/developer/endpoints/relationships/#post_relationship
    # @format :json
    # @authenticated true
    # @rate_limited true
    def deny_user(id, options={})
      options["action"] = "deny"
      response = post("users/#{id}/relationship", options, signature=true)
      response
    end
  end
end
