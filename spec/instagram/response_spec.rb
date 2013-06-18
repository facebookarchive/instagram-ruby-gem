require File.expand_path('../../spec_helper', __FILE__)

describe Instagram::Response do
  Instagram::Configuration::VALID_FORMATS.each do |format|
    context ".new(:format => '#{format}')" do
      before do
        @client = Instagram::Client.new(:format => format, :client_id => 'CID', :client_secret => 'CS', :access_token => 'AT')
      end

      context 'to a standard request' do
        before do
          stub_get("users/4.#{format}").
            with(:query => {:access_token => @client.access_token}).
            to_return(:body => fixture("mikeyk.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8",
                                                                         'x-ratelimit-limit' => '5000',
                                                                         'x-ratelimit-remaining' => '4999'})
        end

        it 'should provide rate limit information on every object returned' do
          user = @client.user(4)
          user.ratelimit.should_not be_nil
          user.ratelimit.limit.should == 5000
          user.ratelimit.remaining.should == 4999
        end
      end
    end
  end
end