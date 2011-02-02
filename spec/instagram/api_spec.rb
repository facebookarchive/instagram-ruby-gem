require File.expand_path('../../spec_helper', __FILE__)

describe Instagram::API do
  before do
    @keys = Instagram::Configuration::VALID_OPTIONS_KEYS
  end

  context "with module configuration" do

    before do
      Instagram.configure do |config|
        @keys.each do |key|
          config.send("#{key}=", key)
        end
      end
    end

    after do
      Instagram.reset
    end

    it "should inherit module configuration" do
      api = Instagram::API.new
      @keys.each do |key|
        api.send(key).should == key
      end
    end

    context "with class configuration" do

      before do
        @configuration = {
          :client_id => 'CID',
          :client_secret => 'CS',
          :access_token => 'AT',
          :adapter => :typhoeus,
          :endpoint => 'http://tumblr.com/',
          :format => :xml,
          :proxy => 'http://shayne:sekret@proxy.example.com:8080',
          :user_agent => 'Custom User Agent',
        }
      end

      context "during initialization"

        it "should override module configuration" do
          api = Instagram::API.new(@configuration)
          @keys.each do |key|
            api.send(key).should == @configuration[key]
          end
        end

      context "after initilization" do

        it "should override module configuration after initialization" do
          api = Instagram::API.new
          @configuration.each do |key, value|
            api.send("#{key}=", value)
          end
          @keys.each do |key|
            api.send(key).should == @configuration[key]
          end
        end
      end
    end
  end
end
