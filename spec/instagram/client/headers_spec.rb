require File.expand_path('../../../spec_helper', __FILE__)

describe Instagram::Client do
  Instagram::Configuration::VALID_FORMATS.each do |format|
    context "any request" do

      before do
        @client = Instagram::Client.new(:format => format, :client_id => 'CID', :client_secret => 'CS', :access_token => 'AT')

        stub_get("media/777/comments.#{format}").
            with(:query => {:access_token => @client.access_token}).
            to_return(:body => fixture("media_comments.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
      end

      it "should return the response headers" do
        comments = @client.media_comments(777)
        comments.should be_a Array
        comments.headers.should_not be_nil
      end

    end
  end
end
