require File.expand_path('../../../spec_helper', __FILE__)

describe Instagram::Client do
  Instagram::Configuration::VALID_FORMATS.each do |format|
    context ".new(:format => '#{format}')" do
      before do
        @client = Instagram::Client.new(:format => format, :client_id => 'CID', :client_secret => 'CS', :access_token => 'AT')
      end

      
      describe ".geography_recent_media" do

        context "with geography ID passed" do

          before do
            stub_get("geographies/12345/media/recent.#{format}").
              with(:query => {:access_token => @client.access_token}).
              to_return(:body => fixture("geography_recent_media.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
          end

          it "should get the correct resource" do
            @client.geography_recent_media(12345)
            a_get("geographies/12345/media/recent.#{format}").
              with(:query => {:access_token => @client.access_token}).
              should have_been_made
          end

          it "should return a list of recent media items within the specifed geography" do
            recent_media = @client.geography_recent_media(12345)
            recent_media.should be_a Array
            recent_media.first.user.username.should == "amandavan"
          end
        end
      end
    end
  end
end
