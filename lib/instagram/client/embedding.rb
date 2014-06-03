module Instagram
  class Client
  	# Defines methods related to embedding
    module Embedding
    	# Returns information about the media associated with the given short link
      #
	    # @overload oembed(url=nil, options={})
	    # 	@param url [String] An instagram short link
	    #   @param options [Hash] A customizable set of options
	    #   @option options [Integer] :maxheight Maximum height of returned media
	    #   @option options [Integer] :maxwidth Maximum width of returned media
	    #   @option options [Integer] :callback A JSON callback to be invoked
	    #   @return [Hashie::Mash] Information about the media associated with given short link
      # 	@example Return information about the media associated with http://instagr.am/p/BUG/
      #   	Instagram.oembed(http://instagr.am/p/BUG/)
      #
      # @see http://instagram.com/developer/embedding/#oembed
      # @format :json
      # @authenticated false
      # @rate_limited true
      def oembed(*args)
        url = args.first
        return nil unless url
        get("oembed?url=#{url}", {}, false, false, true)
      end
    end
  end
end
