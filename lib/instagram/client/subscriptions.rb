require 'openssl'
require 'multi_json'

module Instagram
  class Client
    # Defines methods related to real-time
    module Subscriptions
      # Returns a list of active real-time subscriptions
      #
      # @overload subscriptions(options={})
      #   @return [Hashie::Mash] The list of subscriptions.
      #   @example Returns a list of subscriptions for the authenticated application
      #     Instagram.subscriptions
      # @format :json
      # @authenticated true
      #
      #   Requires client_secret to be set on the client or passed in options
      # @rate_limited true
      # @see https://api.instagram.com/developer/realtime/
      def subscriptions(options={})
        response = get("subscriptions", options.merge(:client_secret => client_secret))
        response
      end

      # Creates a real-time subscription
      #
      # @overload create_subscription(options={})
      #   @param options [Hash] A set of parameters
      #   @option options [String] :object The object you'd like to subscribe to (user, tag, location or geography)
      #   @option options [String] :callback_url The subscription callback URL
      #   @option options [String] :aspect The aspect of the object you'd like to subscribe to (in this case, "media").
      #   @option options [String, Integer] :object_id When specifying a location or tag use the location's ID or tag name respectively
      #   @option options [String, Float] :lat The center latitude of an area, used when subscribing to a geography object
      #   @option options [String, Float] :lng The center longitude of an area, used when subscribing to a geography object
      #   @option options [String, Integer] :radius The distance in meters you'd like to capture around a given point
      # @overload create_subscription(object, callback_url, aspect="media", options={})
      #   @param object [String] The object you'd like to subscribe to (user, tag, location or geography)
      #   @param callback_url [String] The subscription callback URL
      #   @param aspect [String] he aspect of the object you'd like to subscribe to (in this case, "media").
      #   @param options [Hash] Addition options and parameters
      #   @option options [String, Integer] :object_id When specifying a location or tag use the location's ID or tag name respectively
      #   @option options [String, Float] :lat The center latitude of an area, used when subscribing to a geography object
      #   @option options [String, Float] :lng The center longitude of an area, used when subscribing to a geography object
      #   @option options [String, Integer] :radius The distance in meters you'd like to capture around a given point
      #
      #     Note that we only support "media" at this time, but we might support other types of subscriptions in the future.
      #   @return [Hashie::Mash] The subscription created.
      #   @example Creates a new subscription to receive notifications for user media changes.
      #     Instagram.create_subscription("user", "http://example.com/instagram/callback")
      # @format :json
      # @authenticated true
      #
      #   Requires client_secret to be set on the client or passed in options
      # @rate_limited true
      # @see https://api.instagram.com/developer/realtime/
      def create_subscription(*args)
        options = args.last.is_a?(Hash) ? args.pop : {}
        object = args.shift
        callback_url = args.shift
        aspect = args.shift
        options.tap {|o|
          o[:object] = object unless object.nil?
          o[:callback_url] = callback_url unless callback_url.nil?
          o[:aspect] = aspect || o[:aspect] || "media"
        }
        response = post("subscriptions", options.merge(:client_secret => client_secret))
        response
      end

      # Deletes a real-time subscription
      #
      # @overload delete_subscription(options={})
      #   @param options [Hash] Addition options and parameters
      #   @option options [Integer] :subscription_id The subscription's ID
      #   @option options [String] :object When specified will remove all subscriptions of this object type, unless an :object_id is also specified (user, tag, location or geography)
      #   @option options [String, Integer] :object_id When specifying :object, inlcude an :object_id to only remove subscriptions of that object and object_id
      # @overload delete_subscription(subscription_id, options={})
      #   @param subscription_id [Integer] The subscription's ID
      #   @param options [Hash] Addition options and parameters
      #   @option options [String] :object When specified will remove all subscriptions of this object type, unless an :object_id is also specified (user, tag, location or geography)
      #   @option options [String, Integer] :object_id When specifying :object, inlcude an :object_id to only remove subscriptions of that object and object_id
      #   @return [Hashie::Mash]
      #   @example Deletes an application's user change subscription
      #     Instagram.delete_subscription(:object => "user")
      # @format :json
      # @authenticated true
      #
      #   Requires client_secret to be set on the client or passed in options
      # @rate_limited true
      # @see https://api.instagram.com/developer/realtime/
      def delete_subscription(*args)
        options = args.last.is_a?(Hash) ? args.pop : {}
        subscription_id = args.first
        options.merge!(:id => subscription_id) if subscription_id
        response = delete("subscriptions", options.merge(:client_secret => client_secret))
        response
      end

      # As a security measure (to prevent DDoS attacks), Instagram sends a verification request to your server
      # after you request a subscription.
      # This method parses the challenge params and makes sure the call is legitimate.
      #
      # @param params the request parameters sent by Instagram.  (You can pass in a Rails params hash.)
      # @param verify_token the verify token sent in the {#subscribe subscription request}, if you provided one
      #
      # @yield verify_token if you need to compute the verification token
      #                     (for instance, if your callback URL includes a record ID, which you look up
      #                     and use to calculate a hash), you can pass meet_challenge a block, which
      #                     will receive the verify_token received back from Instagram.
      #
      # @return the challenge string to be sent back to Instagram, or false if the request is invalid.
      def meet_challenge(params, verify_token = nil, &verification_block)
        if params["hub.mode"] == "subscribe" &&
            # you can make sure this is legitimate through two ways
            # if your store the token across the calls, you can pass in the token value
            # and we'll make sure it matches
            ((verify_token && params["hub.verify_token"] == verify_token) ||
            # alternately, if you sent a specially-constructed value (such as a hash of various secret values)
            # you can pass in a block, which we'll call with the verify_token sent by Instagram
            # if it's legit, return anything that evaluates to true; otherwise, return nil or false
            (verification_block && yield(params["hub.verify_token"])))
          params["hub.challenge"]
        else
          false
        end
      end

      # Public: As a security measure, all updates from Instagram are signed using
      # X-Hub-Signature: XXXX where XXX is the sha1 of the json payload
      # using your application secret as the key.
      #
      # Example:
      #   # in Rails controller
      #   def receive_update
      #     if Instagram.validate_update(request.body, headers)
      #       ...
      #     else
      #       render text: "not authorized", status: 401
      #     end
      #   end
      def validate_update(body, headers)
        unless client_secret
          raise ArgumentError, "client_secret must be set during configure"
        end

        if request_signature = headers['X-Hub-Signature'] || headers['HTTP_X_HUB_SIGNATURE']
          calculated_signature = OpenSSL::HMAC.hexdigest('sha1', client_secret, body)
          calculated_signature == request_signature
        end
      end

      # Process a subscription notification JSON payload
      #
      # @overload process_subscription(json, &block)
      #   @param json [String] The JSON response received by the Instagram real-time server
      #   @param block [Proc] A callable in which callbacks are defined
      #   @option options [String] :signature Pass in an X-Hub-Signature to use for payload validation
      #   @return [nil]
      #   @example Process and handle a notification for a user media change
      #     Instagram.process_subscription(params[:body]) do |handler|
      #
      #       handler.on_user_changed do |user_id, data|
      #
      #         user = User.by_instagram_id(user_id)
      #         @client = Instagram.client(:access_token => _access_token_for_user(user))
      #         latest_media = @client.user_recent_media[0]
      #         user.media.create_with_hash(latest_media)
      #       end
      #
      #     end
      # @format :json
      # @authenticated true
      #
      #   Requires client_secret to be set on the client or passed in options
      # @rate_limited true
      # @see https://api.instagram.com/developer/realtime/
      def process_subscription(json, options={}, &block)
        raise ArgumentError, "callbacks block expected" unless block_given?

        if options.has_key?(:signature)
          if !client_secret
            raise ArgumentError, "client_secret must be set during configure"
          end
          digest = OpenSSL::Digest.new('sha1')
          verify_signature = OpenSSL::HMAC.hexdigest(digest, client_secret, json)

          if options[:signature] != verify_signature
            raise Instagram::InvalidSignature, "invalid X-Hub-Signature does not match verify signature against client_secret"
          end
        end

        payload = MultiJson.decode(json)
        @changes = Hash.new { |h,k| h[k] = [] }
        for change in payload
          @changes[change['object']] << change
        end
        block.call(self)
      end

      [:user, :tag, :location, :geography].each do |object|
        class_eval <<-RUBY_EVAL, __FILE__, __LINE__ +1
          def on_#{object}_changed(&block)
            for change in @changes['#{object}']
              yield change.delete('object_id'), change
            end
          end
        RUBY_EVAL
      end
    end
  end
end
