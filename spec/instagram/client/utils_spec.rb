require File.expand_path('../../../spec_helper', __FILE__)

describe Instagram::Client do
  Instagram::Configuration::VALID_FORMATS.each do |format|
    context ".new(:format => '#{format}')" do

      before do
        @client = Instagram::Client.new(:format => format, :client_id => 'CID', :client_secret => 'CS', :client_ips => '1.2.3.4', :access_token => 'AT')
      end

      describe '.utils_raw_response' do
        before do
          stub_get("users/self/feed.#{format}").
              with(:query => {:access_token => @client.access_token}).
              to_return(:body => fixture("user_media_feed.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
        end

        before(:each) do
          @response = @client.utils_raw_response
        end

        it 'return raw data' do
          expect(@response).to be_instance_of(Faraday::Response)
        end

        it 'response content headers' do
          expect(@response).to be_respond_to(:headers)
        end
      end
    end
  end
end
