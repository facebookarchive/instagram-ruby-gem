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

  describe ".authorize_url" do

    it "should generate an authorize URL with necessary params" do
      params = { :client_id => "CID", :client_secret => "CS" }

      client = Instagram::Client.new(params)

      redirect_uri = 'http://localhost:4567/oauth/callback'
      url = client.authorize_url(:redirect_uri => redirect_uri)

      params2 = client.send(:access_token_params).merge(params)
      params2[:redirect_uri] = redirect_uri
      params2[:response_type] = "code"
      url2 = client.send(:connection).build_url("/oauth/authorize/", params2).to_s

      url2.should == url
    end
  end

  describe ".get_access_token" do

    before do
      @client = Instagram::Client.new(:client_id => "CID", :client_secret => "CS")
      @url = @client.send(:connection).build_url("/oauth/access_token/").to_s
      stub_request(:post, @url).
        with(:body => {:client_id => "CID", :client_secret => "CS", :redirect_uri => "http://localhost:4567/oauth/callback", :grant_type => "authorization_code", :code => "C"}).
        to_return(:status => 200, :body => fixture("access_token.json"), :headers => {})
    end

    it "should get the correct resource" do
      @client.get_access_token(code="C", :redirect_uri => "http://localhost:4567/oauth/callback")
      a_request(:post, @url).
        with(:body => {:client_id => "CID", :client_secret => "CS", :redirect_uri => "http://localhost:4567/oauth/callback", :grant_type => "authorization_code", :code => "C"}).
        should have_been_made
    end

    it "should return a hash with an access_token and user data" do
      response = @client.get_access_token(code="C", :redirect_uri => "http://localhost:4567/oauth/callback")
      response.access_token.should == "at"
      response.user.username.should == "mikeyk"
    end
  end
end
