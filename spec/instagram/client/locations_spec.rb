require File.expand_path('../../../spec_helper', __FILE__)

describe Instagram::Client do
  Instagram::Configuration::VALID_FORMATS.each do |format|
    context ".new(:format => '#{format}')" do
      before do
        @client = Instagram::Client.new(:format => format, :client_id => 'CID', :client_secret => 'CS', :access_token => 'AT')
      end

      describe ".location" do

        before do
          stub_get("locations/514276.#{format}").
            with(:query => {:access_token => @client.access_token}).
            to_return(:body => fixture("location.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
        end

        it "should get the correct resource" do
          @client.location(514276)
          a_get("locations/514276.#{format}").
            with(:query => {:access_token => @client.access_token}).
            should have_been_made
        end

        it "should return extended information of a given location" do
          location = @client.location(514276)
          location.name.should == "Instagram"
        end
      end

      describe ".location_recent_media" do

        before do
          stub_get("locations/514276/media/recent.#{format}").
            with(:query => {:access_token => @client.access_token}).
            to_return(:body => fixture("location_recent_media.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
        end

        it "should get the correct resource" do
          @client.location_recent_media(514276)
          a_get("locations/514276/media/recent.#{format}").
            with(:query => {:access_token => @client.access_token}).
            should have_been_made
        end

        it "should return a list of media taken at a given location" do
          media = @client.location_recent_media(514276)
          media.data.should be_a Array
          media.data.first.user.username.should == "josh"
        end
      end

      describe ".location_search" do

        before do
          stub_get("locations/search.#{format}").
            with(:query => {:access_token => @client.access_token}).
            with(:query => {:lat => "37.7808851", :lng => "-122.3948632"}).
            to_return(:body => fixture("location_search.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
        end

        it "should get the correct resource" do
          @client.location_search("37.7808851", "-122.3948632")
          a_get("locations/search.#{format}").
            with(:query => {:access_token => @client.access_token}).
            with(:query => {:lat => "37.7808851", :lng => "-122.3948632"}).
            should have_been_made
        end

        it "should return an array of user search results" do
          locations = @client.location_search("37.7808851", "-122.3948632")
          locations.should be_a Array
          locations.first.name.should == "Instagram"
        end
      end
    end
  end
end
