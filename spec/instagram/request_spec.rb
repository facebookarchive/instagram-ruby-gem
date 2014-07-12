require File.expand_path('../../spec_helper', __FILE__)

describe Instagram::Request do
  describe "#post" do
    before do
      @ips = "1.2.3.4"
      @secret = "CS"
      digest = OpenSSL::Digest.new('sha256')
      signature = OpenSSL::HMAC.hexdigest(digest, @secret, @ips)
      @signed_header = [@ips, signature].join('|')
    end

    context "with signature=true" do
      it "should set X-Insta-Forwarded-For header" do
        client = Instagram::Client.new(:client_id => "CID", :client_secret => @secret, :client_ips => @ips, :access_token => "AT")
        url = client.send(:connection).build_url("/media/123/likes.json").to_s
        stub_request(:post, url).
          with(:body => {"access_token"=>"AT"}).
          to_return(:status => 200, :body => "", :headers => {})

        client.post("/media/123/likes", {}, signature=true)
        a_request(:post, url).
          with(:headers => {'X-Insta-Forwarded-For'=> @signed_header}).
          should have_been_made
      end

      it "should not set X-Insta-Fowarded-For header if client_ips is not provided" do
        client = Instagram::Client.new(:client_id => "CID", :client_secret => @secret, :access_token => "AT")
        url = client.send(:connection).build_url("/media/123/likes.json").to_s
        stub_request(:post, url).
          with(:body => {"access_token"=>"AT"}).
          to_return(:status => 200, :body => "", :headers => {})

        client.post("/media/123/likes", {}, signature=true)
        a_request(:post, url).
          with(:headers => {'X-Insta-Forwarded-For'=> @signed_header}).
          should_not have_been_made
      end
    end

    context "with signature=false" do
      it "should set X-Insta-Forwarded-For header" do
        client = Instagram::Client.new(:client_id => "CID", :client_secret => @secret, :client_ips => @ips, :access_token => "AT")
        url = client.send(:connection).build_url("/media/123/likes.json").to_s
        stub_request(:post, url).
          with(:body => {"access_token"=>"AT"}).
          to_return(:status => 200, :body => "", :headers => {})

        client.post("/media/123/likes", {}, signature=false)
        a_request(:post, url).
          with(:headers => {'X-Insta-Forwarded-For'=> @signed_header}).
          should_not have_been_made
      end
    end
  end
end
