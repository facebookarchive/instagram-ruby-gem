require File.expand_path('../spec_helper', __FILE__)

describe Instagram do
  after do
    Instagram.reset
  end

  context "when delegating to a client" do

     before do
       stub_get("users/self/feed.json").
         to_return(:body => fixture("user_media_feed.json"), :headers => {:content_type => "application/json; charset=utf-8"})
     end

     it "should get the correct resource" do
       Instagram.user_media_feed()
       a_get("users/self/feed.json").should have_been_made
     end

     it "should return the same results as a client" do
       Instagram.user_media_feed().should == Instagram::Client.new.user_media_feed()
     end

   end

  describe ".client" do
    it "should be a Instagram::Client" do
      Instagram.client.should be_a Instagram::Client
    end
  end

  describe ".adapter" do
    it "should return the default adapter" do
      Instagram.adapter.should == Instagram::Configuration::DEFAULT_ADAPTER
    end
  end

  describe ".adapter=" do
    it "should set the adapter" do
      Instagram.adapter = :typhoeus
      Instagram.adapter.should == :typhoeus
    end
  end

  describe ".endpoint" do
    it "should return the default endpoint" do
      Instagram.endpoint.should == Instagram::Configuration::DEFAULT_ENDPOINT
    end
  end

  describe ".endpoint=" do
    it "should set the endpoint" do
      Instagram.endpoint = 'http://tumblr.com'
      Instagram.endpoint.should == 'http://tumblr.com'
    end
  end

  describe ".format" do
    it "should return the default format" do
      Instagram.format.should == Instagram::Configuration::DEFAULT_FORMAT
    end
  end

  describe ".format=" do
    it "should set the format" do
      Instagram.format = 'xml'
      Instagram.format.should == 'xml'
    end
  end

  describe ".user_agent" do
    it "should return the default user agent" do
      Instagram.user_agent.should == Instagram::Configuration::DEFAULT_USER_AGENT
    end
  end

  describe ".user_agent=" do
    it "should set the user_agent" do
      Instagram.user_agent = 'Custom User Agent'
      Instagram.user_agent.should == 'Custom User Agent'
    end
  end

    describe ".loud_logger" do
    it "should return the loud_logger status" do
      Instagram.loud_logger.should == nil
    end
  end

  describe ".loud_logger=" do
    it "should set the loud_logger" do
      Instagram.loud_logger = true
      Instagram.loud_logger.should == true
    end
  end

  describe ".configure" do

    Instagram::Configuration::VALID_OPTIONS_KEYS.each do |key|

      it "should set the #{key}" do
        Instagram.configure do |config|
          config.send("#{key}=", key)
          Instagram.send(key).should == key
        end
      end
    end
  end
end
