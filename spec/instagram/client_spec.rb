require File.expand_path('../../spec_helper', __FILE__)

describe Instagram::Client do
  it "should connect using the endpoint configuration" do
    client = Instagram::Client.new
    endpoint = URI.parse(client.endpoint)
    connection = client.send(:connection).build_url(nil).to_s
    expect(connection).to eq(endpoint.to_s)
  end

  it "should not cache the user account across clients" do
    stub_get("users/self.json").
      with(:query => {:access_token => "at1"}).
      to_return(:body => fixture("shayne.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    client1 = Instagram::Client.new(:access_token => "at1")
    expect(client1.send(:get_username)).to eq("shayne")
    stub_get("users/self.json").
      with(:query => {:access_token => "at2"}).
      to_return(:body => fixture("mikeyk.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    client2 = Instagram::Client.new(:access_token => "at2")
    expect(client2.send(:get_username)).to eq("mikeyk")
  end
end
