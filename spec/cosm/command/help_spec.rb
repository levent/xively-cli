require "spec_helper"
require "cosm/command/subscribe"
require "cosm/command/help"

describe Cosm::Command::Help do
  describe "Help.usage_for_command" do
    it "returns the usage if the command exists" do
      usage = Cosm::Command::Help.usage_for_command("help")
      usage.should == "Usage: cosm help [COMMAND]"
    end

    it "returns nil if command does not exist" do
      usage = Cosm::Command::Help.usage_for_command("bleahhaelihef")
      usage.should_not be
    end
  end

  describe "help" do
    it "should show root help with no args" do
      stderr, stdout = execute("help")
      stderr.should == ""
      stdout.should include "Usage: cosm COMMAND [--key API_KEY] [command-specific-options]"
      stdout.should include "subscribe"
      stdout.should include "help"
    end

    it "should show command help and namespace help when ambigious" do
      stderr, stdout = execute("help subscribe")
      stderr.should == ""
      stdout.should include "cosm subscribe"
      stdout.should include "connect to a tcp socket"
    end

    it "should show command help with --help" do
      stderr, stdout = execute("subscribe --help")
      stderr.should == ""
      stdout.should include "Usage: cosm subscribe"
      stdout.should include "connect to a tcp socket for a datastream"
      stdout.should_not include "Additional commands"
    end

    it "should redirect if the command is an alias" do
      stderr, stdout = execute("-v")
      stderr.should == ""
      stdout.should include "#{Cosm::VERSION}"
    end

    it "should show if the command does not exist" do
      pending
      stderr, stdout = execute("help sudo:sandwich")
      stderr.should == <<-STDERR
 !    sudo:sandwich is not a cosm command. See `cosm help`.
STDERR
      stdout.should == ""
    end

    it "should show help with naked -h" do
      stderr, stdout = execute("-h")
      stderr.should == ""
      stdout.should include "Usage: cosm COMMAND"
    end

    it "should show help with naked --help" do
      stderr, stdout = execute("--help")
      stderr.should == ""
      stdout.should include "Usage: cosm COMMAND"
    end

  end
end
