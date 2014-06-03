require File.expand_path('../../spec_helper', __FILE__)

describe Faraday::Response do
  before do
    @client = Instagram::Client.new
  end

  {
    400 => Instagram::BadRequest,
    404 => Instagram::NotFound,
    429 => Instagram::TooManyRequests,
    500 => Instagram::InternalServerError,
    503 => Instagram::ServiceUnavailable
  }.each do |status, exception|
    context "when HTTP status is #{status}" do

      before do
        stub_get('users/self/feed.json').
          to_return(:status => status)
      end

      it "should raise #{exception.name} error" do
        lambda do
          @client.user_media_feed()
        end.should raise_error(exception)
      end

    end
  end

  context "when a 400 is raised" do
    before do
      stub_get('users/self/feed.json').
        to_return(:body => '{"meta":{"error_message": "Bad words are bad."}}', :status => 400)
    end

    it "should return the body error message" do
      expect do
        @client.user_media_feed()
      end.to raise_error(Instagram::BadRequest, /Bad words are bad\./)
    end
  end

  context "when a 400 is raised with no meta but an error_message" do
    before do
      stub_get('users/self/feed.json').
        to_return(:body => '{"error_type": "OAuthException", "error_message": "No matching code found."}', :status => 400)
    end

    it "should return the body error type and message" do
      expect do
        @client.user_media_feed()
      end.to raise_error(Instagram::BadRequest, /OAuthException: No matching code found\./)
    end
  end

  context 'when a 502 is raised with an HTML response' do
    before do
      stub_get('users/self/feed.json').to_return(
        :body => '<html><body><h1>502 Bad Gateway</h1> The server returned an invalid or incomplete response. </body></html>',
        :status => 502
      )
    end

    it 'should raise an Instagram::BadGateway' do
      lambda do
        @client.user_media_feed()
      end.should raise_error(Instagram::BadGateway)
    end
  end

  context 'when a 504 is raised with an HTML response' do
    before do
      stub_get('users/self/feed.json').to_return(
        :body => '<html> <head><title>504 Gateway Time-out</title></head> <body bgcolor="white"> <center><h1>504 Gateway Time-out</h1></center> <hr><center>nginx</center> </body> </html>',
        :status => 504
      )
    end

    it 'should raise an Instagram::GatewayTimeout' do
      lambda do
        @client.user_media_feed()
      end.should raise_error(Instagram::GatewayTimeout)
    end
  end
end
