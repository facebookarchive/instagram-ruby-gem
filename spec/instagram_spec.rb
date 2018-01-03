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
       expect(a_get("users/self/feed.json")).to have_been_made
     end

     it "should return the same results as a client" do
       expect(Instagram.user_media_feed()).to eq(Instagram::Client.new.user_media_feed())
     end

   end

  describe ".client" do
    it "should be a Instagram::Client" do
      expect(Instagram.client).to be_a Instagram::Client
    end
  end

  describe ".adapter" do
    it "should return the default adapter" do
      expect(Instagram.adapter).to eq(Instagram::Configuration::DEFAULT_ADAPTER)
    end
  end

  describe ".adapter=" do
    it "should set the adapter" do
      Instagram.adapter = :typhoeus
      expect(Instagram.adapter).to eq(:typhoeus)
    end
  end

  describe ".endpoint" do
    it "should return the default endpoint" do
      expect(Instagram.endpoint).to eq(Instagram::Configuration::DEFAULT_ENDPOINT)
    end
  end

  describe ".endpoint=" do
    it "should set the endpoint" do
      Instagram.endpoint = 'http://tumblr.com'
      expect(Instagram.endpoint).to eq('http://tumblr.com')
    end
  end

  describe ".format" do
    it "should return the default format" do
      expect(Instagram.format).to eq(Instagram::Configuration::DEFAULT_FORMAT)
    end
  end

  describe ".format=" do
    it "should set the format" do
      Instagram.format = 'xml'
      expect(Instagram.format).to eq('xml')
    end
  end

  describe ".user_agent" do
    it "should return the default user agent" do
      expect(Instagram.user_agent).to eq(Instagram::Configuration::DEFAULT_USER_AGENT)
    end
  end

  describe ".user_agent=" do
    it "should set the user_agent" do
      Instagram.user_agent = 'Custom User Agent'
      expect(Instagram.user_agent).to eq('Custom User Agent')
    end
  end

    describe ".loud_logger" do
    it "should return the loud_logger status" do
      expect(Instagram.loud_logger).to eq(nil)
    end
  end

  describe ".loud_logger=" do
    it "should set the loud_logger" do
      Instagram.loud_logger = true
      expect(Instagram.loud_logger).to eq(true)
    end
  end

  describe ".configure" do

    Instagram::Configuration::VALID_OPTIONS_KEYS.each do |key|

      it "should set the #{key}" do
        Instagram.configure do |config|
          config.send("#{key}=", key)
          expect(Instagram.send(key)).to eq(key)
        end
      end
    end
  end
end
