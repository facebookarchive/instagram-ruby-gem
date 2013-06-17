module Instagram
  module Response
    def self.create( response_hash )
      data = response_hash.data.dup rescue response_hash
      data.extend( self )
      data.instance_exec do
        @pagination = response_hash.pagination
        @meta = response_hash.meta
      end
      data
    end

    def next
      if pagination.next_url
        client = Instagram::Client.new(Instagram.options)
        pagination.next_url.sub!('http://', 'https://') #Make the URL secure if it isn't already
        response = client.get(pagination.next_url.sub(Instagram.endpoint, ''), {}, false, true)
        response
      end
    end

    attr_reader :pagination
    attr_reader :meta
  end
end
