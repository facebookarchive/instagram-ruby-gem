require File.expand_path('../../../spec_helper', __FILE__)

describe Instagram::Client do
  Instagram::Configuration::VALID_FORMATS.each do |format|
    context ".new(:format => '#{format}')" do
      before do
        @client = Instagram::Client.new(:format => format, :client_id => 'CID', :client_secret => 'CS', :access_token => 'AT')
      end

      describe ".media_item" do

        before do
          stub_get("media/18600493.#{format}").
            with(:query => {:access_token => @client.access_token}).
            to_return(:body => fixture("media.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
        end

        it "should get the correct resource" do
          @client.media_item(18600493)
          a_get("media/18600493.#{format}").
            with(:query => {:access_token => @client.access_token}).
            should have_been_made
        end

        it "should return extended information of a given media item" do
          media = @client.media_item(18600493)
          media.user.username.should == "mikeyk"
        end
      end

      describe ".media_shortcode" do

        before do
          stub_get('media/shortcode/BG9It').
            with(:query => {:access_token => @client.access_token}).
            to_return(:body => fixture("media_shortcode.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
        end

        it "should get the correct resource" do
          @client.media_shortcode('BG9It')
          a_get('media/shortcode/BG9It').
            with(:query => {:access_token => @client.access_token}).
            should have_been_made
        end

        it "should return extended information of a given media item" do
          media = @client.media_shortcode('BG9It')
          media.user.username.should == 'mikeyk'
        end
      end

      describe ".media_popular" do

        before do
          stub_get("media/popular.#{format}").
            with(:query => {:access_token => @client.access_token}).
            to_return(:body => fixture("media_popular.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
        end

        it "should get the correct resource" do
          @client.media_popular
          a_get("media/popular.#{format}").
            with(:query => {:access_token => @client.access_token}).
            should have_been_made
        end

        it "should return popular media items" do
          media_popular = @client.media_popular
          media_popular.should be_a Array
          media_popular.first.user.username == "babycamera"
        end
      end

      describe ".media_search" do

        before do
          stub_get("media/search.#{format}").
            with(:query => {:access_token => @client.access_token}).
            with(:query => {:lat => "37.7808851", :lng => "-122.3948632"}).
            to_return(:body => fixture("media_search.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
        end

        it "should get the correct resource" do
          @client.media_search("37.7808851", "-122.3948632")
          a_get("media/search.#{format}").
            with(:query => {:access_token => @client.access_token}).
            with(:query => {:lat => "37.7808851", :lng => "-122.3948632"}).
            should have_been_made
        end

        it "should return an array of user search results" do
          media_search = @client.media_search("37.7808851", "-122.3948632")
          media_search.should be_a Array
          media_search.first.user.username.should == "mikeyk"
        end
      end
    end
  end
end
