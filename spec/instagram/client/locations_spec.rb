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
          media.should be_a Array
          media.first.user.username.should == "josh"
        end
      end

      describe ".location_search_lat_lng" do

        before do
          stub_get("locations/search.#{format}").
            with(:query => {:access_token => @client.access_token}).
            with(:query => {:lat => "37.7808851", :lng => "-122.3948632"}).
            to_return(:body => fixture("location_search.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
        end

        it "should get the correct resource by lat/lng" do
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

      describe ".location_search_lat_lng_distance" do

        before do
          stub_get("locations/search.#{format}").
            with(:query => {:access_token => @client.access_token}).
            with(:query => {:lat => "37.7808851", :lng => "-122.3948632", :distance => "5000"}).
            to_return(:body => fixture("location_search.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
        end

        it "should get the correct resource by lat/lng/distance" do
          @client.location_search("37.7808851", "-122.3948632", "5000")
          a_get("locations/search.#{format}").
            with(:query => {:access_token => @client.access_token}).
            with(:query => {:lat => "37.7808851", :lng => "-122.3948632", :distance => "5000"}).
            should have_been_made
        end

        it "should return an array of user search results" do
          locations = @client.location_search("37.7808851", "-122.3948632", "5000")
          locations.should be_a Array
          locations.first.name.should == "Instagram"
        end
      end

      describe ".location_search_foursquare_v2_id" do

        before do
          stub_get("locations/search.#{format}").
            with(:query => {:access_token => @client.access_token}).
            with(:query => {:foursquare_v2_id => "3fd66200f964a520c5f11ee3"}).
            to_return(:body => fixture("location_search_fsq.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
        end

        it "should get the correct resource by foursquare_v2_id" do
          @client.location_search("3fd66200f964a520c5f11ee3")
          a_get("locations/search.#{format}").
            with(:query => {:access_token => @client.access_token}).
            with(:query => {:foursquare_v2_id => "3fd66200f964a520c5f11ee3"}).
            should have_been_made
        end

        it "should return an array of user search results" do
          locations = @client.location_search("3fd66200f964a520c5f11ee3")
          locations.should be_a Array
          locations.first.name.should == "Schiller's Liquor Bar"
        end
      end

    end
  end
end
