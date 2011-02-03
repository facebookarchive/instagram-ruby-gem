require File.expand_path('../../../spec_helper', __FILE__)

describe Instagram::Client do
  Instagram::Configuration::VALID_FORMATS.each do |format|
    context ".new(:format => '#{format}')" do
      before do
        @client = Instagram::Client.new(:format => format, :client_id => 'CID', :access_token => 'AT')
      end
      
      describe ".user" do
        
        context "with user ID passed" do
          
          before do
            stub_get("users/4.#{format}").
              with(:query => {:access_token => @client.access_token}).
              to_return(:body => fixture("mikeyk.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
          end
          
          it "should get the correct resource" do
            @client.user(4)
            a_get("users/4.#{format}").
              with(:query => {:access_token => @client.access_token}).
              should have_been_made
          end
          
          it "should return extended information of a given user" do
            user = @client.user(4)
            user.first_name.should == "Mike"
            user.last_name.should == "Krieger"
          end
          
        end
        
        context "without user ID passed" do

          before do
            stub_get("users/self.#{format}").
              with(:query => {:access_token => @client.access_token}).
              to_return(:body => fixture("shayne.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
          end

          it "should get the correct resource" do
            @client.user()
            a_get("users/self.#{format}").
              with(:query => {:access_token => @client.access_token}).
              should have_been_made
          end
        end
      end
      
      describe ".user_search" do
        
        before do
          stub_get("users/search.#{format}").
            with(:query => {:access_token => @client.access_token}).
            with(:query => {:q => "Shayne Sweeney"}).
            to_return(:body => fixture("user_search.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
        end
        
        it "should get the correct resource" do
          @client.user_search("Shayne Sweeney")
          a_get("users/search.#{format}").
            with(:query => {:access_token => @client.access_token}).
            with(:query => {:q => "Shayne Sweeney"}).
            should have_been_made
        end
        
        it "should return an array of user search results" do
          users = @client.user_search("Shayne Sweeney")
          users.should be_a Array
          users.first.username.should == "shayne"
        end
      end
      
      describe ".user_follows" do
        
        context "with user ID passed" do
          
          before do
            stub_get("users/4/follows.#{format}").
              with(:query => {:access_token => @client.access_token}).
              to_return(:body => fixture("follows.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
          end
          
          it "should get the correct resource" do
            @client.user_follows(4)
            a_get("users/4/follows.#{format}").
              with(:query => {:access_token => @client.access_token}).
              should have_been_made
          end
          
          it "should return a list of users whom a given user follows" do
            follows = @client.user_follows(4)
            follows.should be_a Array
            follows.first.username.should == "heartsf"
          end
        end
        
        context "without user ID passed" do
          
          before do
            stub_get("users/self/follows.#{format}").
              with(:query => {:access_token => @client.access_token}).
              to_return(:body => fixture("follows.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
          end
          
          it "should get the correct resource" do
            @client.user_follows
            a_get("users/self/follows.#{format}").
              with(:query => {:access_token => @client.access_token}).
              should have_been_made
          end
        end
      end
      
      describe ".user_followed_by" do
        
        context "with user ID passed" do
          
          before do
            stub_get("users/4/followed-by.#{format}").
              with(:query => {:access_token => @client.access_token}).
              to_return(:body => fixture("followed_by.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
          end
          
          it "should get the correct resource" do
            @client.user_followed_by(4)
            a_get("users/4/followed-by.#{format}").
              with(:query => {:access_token => @client.access_token}).
              should have_been_made
          end
          
          it "should return a list of users whom a given user is followed by" do
            followed_by = @client.user_followed_by(4)
            followed_by.should be_a Array
            followed_by.first.username.should == "bojieyang"
          end
        end
        
        context "without user ID passed" do
          
          before do
            stub_get("users/self/followed-by.#{format}").
              with(:query => {:access_token => @client.access_token}).
              to_return(:body => fixture("followed_by.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
          end
          
          it "should get the correct resource" do
            @client.user_followed_by
            a_get("users/self/followed-by.#{format}").
              with(:query => {:access_token => @client.access_token}).
              should have_been_made
          end
        end
      end
      
      describe ".user_media_feed" do
        
        before do
          stub_get("users/self/feed.#{format}").
            with(:query => {:access_token => @client.access_token}).
            to_return(:body => fixture("user_media_feed.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
        end
        
        it "should get the correct resource" do
          @client.user_media_feed
          a_get("users/self/feed.#{format}").
            with(:query => {:access_token => @client.access_token}).
            should have_been_made
        end
      end
      
      describe ".user_recent_media" do
        
        context "with user ID passed" do
          
          before do
            stub_get("users/4/media/recent.#{format}").
              with(:query => {:access_token => @client.access_token}).
              to_return(:body => fixture("recent_media.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
          end
          
          it "should get the correct resource" do
            @client.user_recent_media(4)
            a_get("users/4/media/recent.#{format}").
              with(:query => {:access_token => @client.access_token}).
              should have_been_made
          end
          
          it "should return a list of recent media items for the given user" do
            recent_media = @client.user_recent_media(4)
            recent_media.should be_a Array
            recent_media.first.user.username.should == "shayne"
          end
        end
        
        context "without user ID passed" do
          
          before do
            stub_get("users/self/media/recent.#{format}").
              with(:query => {:access_token => @client.access_token}).
              to_return(:body => fixture("recent_media.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
          end
          
          it "should get the correct resource" do
            @client.user_recent_media
            a_get("users/self/media/recent.#{format}").
              with(:query => {:access_token => @client.access_token}).
              should have_been_made
          end            
        end
      end
    end
  end
end