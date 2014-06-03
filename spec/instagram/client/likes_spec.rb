require File.expand_path('../../../spec_helper', __FILE__)

describe Instagram::Client do
  Instagram::Configuration::VALID_FORMATS.each do |format|
    context ".new(:format => '#{format}')" do

      before do
        @client = Instagram::Client.new(:format => format, :client_id => 'CID', :client_secret => 'CS', :client_ips => '1.2.3.4', :access_token => 'AT')
      end

      describe ".media_likes" do

        before do
          stub_get("media/777/likes.#{format}").
            with(:query => {:access_token => @client.access_token}).
            to_return(:body => fixture("media_likes.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
        end

        it "should get the correct resource" do
          @client.media_likes(777)
          a_get("media/777/likes.#{format}").
            with(:query => {:access_token => @client.access_token}).
            should have_been_made
        end

        it "should return an array of user search results" do
          comments = @client.media_likes(777)
          comments.should be_a Array
          comments.first.username.should == "chris"
        end
      end

      describe ".like_media" do

        before do
          stub_post("media/777/likes.#{format}").
            with(:body => {:access_token => @client.access_token}).
            to_return(:body => fixture("media_liked.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
        end

        it "should get the correct resource" do
          @client.like_media(777)
          a_post("media/777/likes.#{format}").
            with(:body => {:access_token => @client.access_token}).
            should have_been_made
        end
      end

      describe ".unlike_media" do

        before do
          stub_delete("media/777/likes.#{format}").
            with(:query => {:access_token => @client.access_token}).
            to_return(:body => fixture("media_unliked.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
        end

        it "should get the correct resource" do
          @client.unlike_media(777)
          a_delete("media/777/likes.#{format}").
            with(:query => {:access_token => @client.access_token}).
            should have_been_made
        end
      end
    end
  end
end