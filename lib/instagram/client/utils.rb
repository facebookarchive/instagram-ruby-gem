module Instagram
  class Client
    # @private
    module Utils
      # Returns the raw full response including all headers. Can be used to access the values for 'X-Ratelimit-Limit' and 'X-Ratelimit-Remaining' 
      # ==== Examples
      #   
      #   client = Instagram.client(:access_token => session[:access_token])
      #   response = client.utils_raw_response
      #   remaining = response.headers[:x_ratelimit_remaining]
      #   limit = response.headers[:x_ratelimit_limit]
      #
      def utils_raw_response
        response = get('users/self/feed',nil, false, true)
        response
      end
    
      private

      # Returns the configured user name or the user name of the authenticated user
      #
      # @return [String]
      def get_username
        @user_name ||= self.user.username
      end
    end
  end
end
