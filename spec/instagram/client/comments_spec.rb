require File.expand_path('../../../spec_helper', __FILE__)

describe Instagram::Client do
  Instagram::Configuration::VALID_FORMATS.each do |format|
    context ".new(:format => '#{format}')" do

      before do
        @client = Instagram::Client.new(:format => format, :client_id => 'CID', :client_secret => 'CS', :access_token => 'AT')
      end

      describe ".media_comments" do

        before do
          stub_get("media/777/comments.#{format}").
            with(:query => {:access_token => @client.access_token}).
            to_return(:body => fixture("media_comments.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
        end

        it "should get the correct resource" do
          @client.media_comments(777)
          a_get("media/777/comments.#{format}").
            with(:query => {:access_token => @client.access_token}).
            should have_been_made
        end

        it "should return an array of user search results" do
          comments = @client.media_comments(777)
          comments.should be_a Array
          comments.first.text.should == "Vet visit"
        end
      end

      describe ".create_media_comment" do

        before do
          stub_post("media/777/comments.#{format}").
            with(:body => {:text => "hi there", :access_token => @client.access_token}).
            to_return(:body => fixture("media_comment.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
        end

        it "should get the correct resource" do
          @client.create_media_comment(777, "hi there")
          a_post("media/777/comments.#{format}").
            with(:body => {:text => "hi there", :access_token => @client.access_token}).
            should have_been_made
        end

        it "should return the new comment when successful" do
          comment = @client.create_media_comment(777, "hi there")
          comment.text.should == "hi there"
        end
      end

      describe ".delete_media_comment" do

        before do
          stub_delete("media/777/comments/1234.#{format}").
            with(:query => {:access_token => @client.access_token}).
            to_return(:body => fixture("media_comment_deleted.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
        end

        it "should get the correct resource" do
          @client.delete_media_comment(777, 1234)
          a_delete("media/777/comments/1234.#{format}").
            with(:query => {:access_token => @client.access_token}).
            should have_been_made
        end
      end
    end
  end
end