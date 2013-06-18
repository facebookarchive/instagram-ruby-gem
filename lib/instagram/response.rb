module Instagram
  module Response
    def self.create( response_hash, ratelimit_hash )
      data = response_hash.data.dup rescue response_hash
      data.extend( self )
      data.instance_exec do
        @pagination = response_hash.pagination
        @meta = response_hash.meta
        @ratelimit = ::Hashie::Mash.new(ratelimit_hash)
      end
      data
    end

    def next
      if pagination.next_url
        client = Instagram.client(Instagram.options)
        pagination.next_url.sub!('http://', 'https://') #Make the URL secure if it isn't already
        response = client.get(pagination.next_url.sub(Instagram.endpoint, ''), {}, false, true)
        response
      else
        []
      end
    end

    attr_reader :pagination
    attr_reader :meta
    attr_reader :ratelimit
  end
end
