require "spec_helper"
require "xively/command"

class FakeResponse

  attr_accessor :body, :headers

  def initialize(attributes)
    self.body, self.headers = attributes[:body], attributes[:headers]
  end

  def to_s
    body
  end

end

describe Xively::Command do
  before {
    Xively::Command.load
  }

  it "correctly resolves commands" do
    class Xively::Command::Test; end
    class Xively::Command::Test::Multiple; end

    require "xively/command/help"
    require "xively/command/subscribe"

    Xively::Command.parse("unknown").should be_nil
    Xively::Command.parse("subscribe").should include(:klass => Xively::Command::Subscribe, :method => :index)
    Xively::Command.parse("version").should include(:klass => Xively::Command::Version, :method => :index)
  end

  context "help" do
    it "works as a prefix" do
      xively("help subscribe").should =~ /connect to a tcp socket for a feed or datastream/
    end

    it "works as an option" do
      xively("subscribe -h").should =~ /connect to a tcp socket for a feed or datastream/
      xively("subscribe --help").should =~ /connect to a tcp socket for a feed or datastream/
    end
  end

  context "when no commands match" do

    it "displays the version if -v or --version is used" do
      xively("-v").chomp.should == Xively::VERSION
      xively("--version").chomp.should == Xively::VERSION
    end

    it "suggests you seek help" do
      original_stderr, original_stdout = $stderr, $stdout
      $stderr = captured_stderr = StringIO.new
      $stdout = captured_stdout = StringIO.new
      begin
        execute("aps")
      rescue SystemExit
      end
      captured_stderr.string.should == <<-STDERR
`aps` is not a xively command.
See `xively help` for a list of available commands.
STDERR
      captured_stdout.string.should == ""
      $stderr, $stdout = original_stderr, original_stdout
    end

  end
end
