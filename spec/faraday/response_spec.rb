require File.expand_path('../../spec_helper', __FILE__)

describe Faraday::Response do
  before do
    @client = Instagram::Client.new
  end

  {
    400 => Instagram::BadRequest,
    404 => Instagram::NotFound,
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
end
