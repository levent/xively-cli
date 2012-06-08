require "spec_helper"
require "cosm/command"

class FakeResponse

  attr_accessor :body, :headers

  def initialize(attributes)
    self.body, self.headers = attributes[:body], attributes[:headers]
  end

  def to_s
    body
  end

end

describe Cosm::Command do
  before {
    Cosm::Command.load
  }

  it "correctly resolves commands" do
    class Cosm::Command::Test; end
    class Cosm::Command::Test::Multiple; end

    require "cosm/command/help"
    require "cosm/command/subscribe"

    Cosm::Command.parse("unknown").should be_nil
    Cosm::Command.parse("subscribe").should include(:klass => Cosm::Command::Subscribe, :method => :index)
    Cosm::Command.parse("version").should include(:klass => Cosm::Command::Version, :method => :index)
  end

  context "help" do
    it "works as a prefix" do
      cosm("help subscribe").should =~ /connect to a tcp socket for a datastream/
    end

    it "works as an option" do
      cosm("subscribe -h").should =~ /connect to a tcp socket for a datastream/
      cosm("subscribe --help").should =~ /connect to a tcp socket for a datastream/
    end
  end

  context "when no commands match" do

    it "displays the version if -v or --version is used" do
      cosm("-v").chomp.should == Cosm::VERSION
      cosm("--version").chomp.should == Cosm::VERSION
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
`aps` is not a cosm command.
See `cosm help` for a list of available commands.
STDERR
      captured_stdout.string.should == ""
      $stderr, $stdout = original_stderr, original_stdout
    end

  end
end
