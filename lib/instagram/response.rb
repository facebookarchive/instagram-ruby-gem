module Instagram
  module Response
    def self.create( response_hash , headers)
      data = response_hash.data.dup rescue response_hash
      data.extend( self )
      data.instance_exec do
        @pagination = response_hash.pagination
        @meta = response_hash.meta
        @headers = headers
      end
      data
    end

    attr_reader :pagination
    attr_reader :meta
    attr_reader :headers
  end
end
