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
          :access_token => 'AT',
          :adapter => :typhoeus,
          :client_id => 'CID',
          :client_secret => 'CS',
          :client_ips => '1.2.3.4',
          :connection_options => { :ssl => { :verify => true } },
          :redirect_uri => 'http://http://localhost:4567/oauth/callback',
          :endpoint => 'http://tumblr.com/',
          :format => :xml,
          :proxy => 'http://shayne:sekret@proxy.example.com:8080',
          :scope => 'comments relationships',
          :user_agent => 'Custom User Agent',
          :no_response_wrapper => true,
          :loud_logger => true,
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

        let(:api) { Instagram::API.new }

        before do
          @configuration.each do |key, value|
            api.send("#{key}=", value)
          end
        end

        it "should override module configuration after initialization" do
          @keys.each do |key|
            api.send(key).should == @configuration[key]
          end
        end

        describe "#connection" do
          it "should use the connection_options" do
            Faraday::Connection.should_receive(:new).with(include(:ssl => { :verify => true }))
            api.send(:connection)
          end
        end
      end
    end
  end

  describe '#config' do
    subject { Instagram::API.new }

    let(:config) do
      c = {}; @keys.each {|key| c[key] = key }; c
    end

    it "returns a hash representing the configuration" do
      @keys.each do |key|
        subject.send("#{key}=", key)
      end
      subject.config.should == config
    end
  end

  describe ".authorize_url" do

    it "should generate an authorize URL with necessary params" do
      params = { :client_id => "CID", :client_secret => "CS" }

      client = Instagram::Client.new(params)

      redirect_uri = 'http://localhost:4567/oauth/callback'
      url = client.authorize_url(:redirect_uri => redirect_uri)

      options = {
        :redirect_uri => redirect_uri,
        :response_type => "code"
      }
      params2 = client.send(:authorization_params).merge(options)

      url2 = client.send(:connection).build_url("/oauth/authorize/", params2).to_s

      url2.should == url
    end

    it "should not include client secret in URL params" do
      params = { :client_id => "CID", :client_secret => "CS" }
      client = Instagram::Client.new(params)
      redirect_uri = 'http://localhost:4567/oauth/callback'
      url = client.authorize_url(:redirect_uri => redirect_uri)
      url.should_not include("client_secret")
    end

    describe "scope param" do
      it "should include the scope if there is one set" do
        params = { :scope => "comments likes" }
        client = Instagram::Client.new(params)
        redirect_uri = 'http://localhost:4567/oauth/callback'
        url = client.authorize_url(:redirect_uri => redirect_uri)
        url.should include("scope")
      end

      it "should not include the scope if the scope is blank" do
        params = { :scope => "" }
        client = Instagram::Client.new(params)
        redirect_uri = 'http://localhost:4567/oauth/callback'
        url = client.authorize_url(:redirect_uri => redirect_uri)
        url.should_not include("scope")
      end
    end

    describe "redirect_uri" do
      it "should fall back to configuration redirect_uri if not passed as option" do
        redirect_uri = 'http://localhost:4567/oauth/callback'
        params = { :redirect_uri => redirect_uri }
        client = Instagram::Client.new(params)
        url = client.authorize_url()
        url.should =~ /redirect_uri=#{URI.escape(redirect_uri, Regexp.union('/',':'))}/
      end

      it "should override configuration redirect_uri if passed as option" do
        redirect_uri_config = 'http://localhost:4567/oauth/callback_config'
        params = { :redirect_uri => redirect_uri_config }
        client = Instagram::Client.new(params)
        redirect_uri_option = 'http://localhost:4567/oauth/callback_option'
        options = { :redirect_uri => redirect_uri_option }
        url = client.authorize_url(options)
        url.should =~ /redirect_uri=#{URI.escape(redirect_uri_option, Regexp.union('/',':'))}/
      end
    end
  end

  describe ".get_access_token" do

    describe "common functionality" do
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

    describe "redirect_uri param" do

      before do
        @redirect_uri_config = "http://localhost:4567/oauth/callback_config"
        @client = Instagram::Client.new(:client_id => "CID", :client_secret => "CS", :redirect_uri => @redirect_uri_config)
        @url = @client.send(:connection).build_url("/oauth/access_token/").to_s
        stub_request(:post, @url)
      end

      it "should fall back to configuration redirect_uri if not passed as option" do
        @client.get_access_token(code="C")
        a_request(:post, @url).
          with(:body => hash_including({:redirect_uri => @redirect_uri_config})).
          should have_been_made
      end

      it "should override configuration redirect_uri if passed as option" do
        redirect_uri_option = "http://localhost:4567/oauth/callback_option"
        @client.get_access_token(code="C", :redirect_uri => redirect_uri_option)
        a_request(:post, @url).
          with(:body => hash_including({:redirect_uri => redirect_uri_option})).
          should have_been_made
      end
    end

    describe "loud_logger param" do

      before do
        @client = Instagram::Client.new(:loud_logger => true)
      end

      context "outputs to STDOUT with faraday logs when enabled" do
        before do
          stub_get('users/self/feed.json').
          to_return(:body => fixture("user_media_feed.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        end

        it "should return the body error message" do
          output = capture_output do
            @client.user_media_feed()
          end

          expect(output).to include 'INFO -- : Started GET request to: https://api.instagram.com/v1/users/self/feed.json'
          expect(output).to include 'DEBUG -- : Response Headers:'
          expect(output).to include "User-Agent : Instagram Ruby Gem #{Instagram::VERSION}"
          expect(output).to include 'http://distillery.s3.amazonaws.com/media/2011/01/31/0f8e832c3dc6420bb6ddf0bd09f032f6_6.jpg'
        end
      end

      context "shows STDOUT output when errors occur" do

        before do
          stub_get('users/self/feed.json').
          to_return(:body => '{"meta":{"error_message": "Bad words are bad."}}', :status => 400)
        end

        it "should return the body error message" do
          output = capture_output do
            @client.user_media_feed() rescue nil
          end

          expect(output).to include 'INFO -- : Started GET request to: https://api.instagram.com/v1/users/self/feed.json'
          expect(output).to include 'DEBUG -- : Response Headers:'
          expect(output).to include "User-Agent : Instagram Ruby Gem #{Instagram::VERSION}"
          expect(output).to include '{"meta":{"error_message": "Bad words are bad."}}'
        end
      end

      context "will redact API keys if INSTAGRAM_GEM_REDACT=true" do
        before do
          stub_get('users/self/feed.json').
          to_return(:body => fixture("user_media_feed.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        end

        it "should redact API keys" do
          ENV.stub(:[]).with('http_proxy').and_return(nil)
          ENV.stub(:[]).with('INSTAGRAM_GEM_REDACT').and_return('true')

          output = capture_output do
            @client.user_media_feed()
          end

          expect(output).to include 'INFO -- : Started GET request to: https://api.instagram.com/v1/users/self/feed.json'
          expect(output).to include 'DEBUG -- : Response Headers:'
          expect(output).to include "User-Agent : Instagram Ruby Gem #{Instagram::VERSION}"
          expect(output).to include 'http://distillery.s3.amazonaws.com/media/2011/01/31/0f8e832c3dc6420bb6ddf0bd09f032f6_6.jpg'
          expect(output).to include 'access_token=[ACCESS-TOKEN]'
        end
      end
    end
  end
end
