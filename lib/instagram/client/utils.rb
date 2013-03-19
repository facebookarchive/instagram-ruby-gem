module Instagram
  class Client
    # @private
    module Utils
      def utils_raw_response
        response = get('users/self/feed',nil,true)
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