require File.expand_path('../../../spec_helper', __FILE__)

describe Instagram::Client do
  Instagram::Configuration::VALID_FORMATS.each do |format|
    context ".new(:format => '#{format}')" do
      before do
        @client = Instagram::Client.new(:format => format, :client_id => 'CID', :client_secret => 'CS', :access_token => 'AT')
      end

      describe ".oembed" do
        before do
          stub_get("oembed").
            with(:query => {:access_token => @client.access_token, :url => "http://instagram.com/p/abcdef"}).
            to_return(:body => fixture("oembed.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
        end

        it "should get the correct resource" do
          @client.oembed("http://instagram.com/p/abcdef")
          a_get("oembed?url=http://instagram.com/p/abcdef").
            with(:query => {:access_token => @client.access_token}).
            should have_been_made
        end

        it "should return the oembed information for an instagram media url" do
          oembed = @client.oembed("http://instagram.com/p/abcdef")
          oembed.media_id.should == "123657555223544123_41812344"
        end

        it "should return nil if a URL is not provided" do
          oembed = @client.oembed
          oembed.should be_nil
        end
      end
    end
  end
end
