require "spec_helper"
require "cosm/command/version"

module Cosm::Command
  describe Version do

    it "shows version info" do
      stderr, stdout = execute("version")
      stderr.should == ""
      stdout.should == <<-STDOUT
#{Cosm::VERSION}
STDOUT
    end

  end
end
