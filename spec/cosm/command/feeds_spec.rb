require "spec_helper"
require "cosm/command/feeds"
require "cosm-rb"

describe Cosm::Command::Feeds do

  describe "create" do
    it "should require a title" do
      stderr, stdout = execute("feeds:create")
      stderr.should =~ /Please provide a title/
      stdout.should == ""
    end

    it "should require an api key" do
      stderr, stdout = execute("feeds:create monitor")
      stderr.should =~ /Usage: cosm  feeds:create/
    end

    it "should should create a feed" do
      feed = Cosm::Feed.new
      feed.title = 'Monitor'
      response = mock(HTTParty::Response, :code => 201, :headers => {'location' => 'http://cosm.com/feeds/504'})

      Cosm::Client.should_receive(:post).with(
        '/v2/feeds.json',
        :headers => {'X-ApiKey' => '1234'},
        :body => feed.to_json).and_return(response)
      stderr, stdout = execute("feeds:create Monitor -k 1234")
      stderr.should == ""
      stdout.should =~ /Creating feed \"Monitor\"\.\.\./
      stdout.should =~ /http:\/\/cosm\.com\/feeds\/504/
    end
  end

end
