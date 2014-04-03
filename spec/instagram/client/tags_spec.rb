require File.expand_path('../../../spec_helper', __FILE__)

describe Instagram::Client do
  Instagram::Configuration::VALID_FORMATS.each do |format|
    context ".new(:format => '#{format}')" do
      before do
        @client = Instagram::Client.new(:format => format, :client_id => 'CID', :client_secret => 'CS', :access_token => 'AT')
      end

      describe ".tag" do

        before do
          stub_get("tags/cat.#{format}").
            with(:query => {:access_token => @client.access_token}).
            to_return(:body => fixture("tag.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
        end

        it "should get the correct resource" do
          @client.tag('cat')
          a_get("tags/cat.#{format}").
            with(:query => {:access_token => @client.access_token}).
            should have_been_made
        end

        it "should return extended information of a given media item" do
          tag = @client.tag('cat')
          tag.name.should == 'cat'
        end
      end

      describe ".tag_recent_media" do

        before do
          stub_get("tags/cat/media/recent.#{format}").
            with(:query => {:access_token => @client.access_token}).
            to_return(:body => fixture("tag_recent_media.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
        end

        it "should get the correct resource" do
          @client.tag_recent_media('cat')
          a_get("tags/cat/media/recent.#{format}").
            with(:query => {:access_token => @client.access_token}).
            should have_been_made
        end

        it "should return a list of media taken at a given location" do
          media = @client.tag_recent_media('cat')
          media.should be_a Array
          media.first.user.username.should == "amandavan"
        end

      end

      describe ".tag_search" do

        before do
          stub_get("tags/search.#{format}").
            with(:query => {:access_token => @client.access_token}).
            with(:query => {:q => 'cat'}).
            to_return(:body => fixture("tag_search.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
        end

        it "should get the correct resource" do
          @client.tag_search('cat')
          a_get("tags/search.#{format}").
            with(:query => {:access_token => @client.access_token}).
            with(:query => {:q => 'cat'}).
            should have_been_made
        end

        it "should return an array of user search results" do
          tags = @client.tag_search('cat')
          tags.should be_a Array
          tags.first.name.should == "cats"
        end
      end
    end
  end
end
