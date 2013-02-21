module Instagram
  class Client
    module Embedding
      def oembed(*args)
        url = args.first
        return nil unless url
        get("oembed?url=#{url}", {}, false, true)
      end
    end
  end
end
