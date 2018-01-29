module Instagram
  module Response
    def self.create( response_hash, ratelimit_hash )
      return if handle_potential_error(response_hash)

      data = response_hash.data.dup rescue response_hash
      data.extend( self )
      data.instance_exec do
        %w{pagination meta}.each do |k|
          response_hash.public_send(k).tap do |v|
            instance_variable_set("@#{k}", v) if v
          end
        end
        @ratelimit = ::Hashie::Mash.new(ratelimit_hash)
      end
      data
    end

    def self.handle_potential_error(response_hash)
      err = begin
        response_hash['error_type'] == 'OAuthForbiddenException'
      rescue nil
      end

      if err
        raise Instagram::RequestNotSignedCorrectly, response_hash['error_message']
      end
    end

    attr_reader :pagination
    attr_reader :meta
    attr_reader :ratelimit
  end
end
