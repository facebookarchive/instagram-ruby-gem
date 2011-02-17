module Instagram
  class Client
    # @private
    module Utils
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