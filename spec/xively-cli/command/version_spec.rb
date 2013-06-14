require "spec_helper"
require "xively-cli/command/version"

module Xively::Command
  describe Version do

    it "shows version info" do
      stderr, stdout = execute("version")
      stderr.should == ""
      stdout.should == <<-STDOUT
#{Xively::VERSION}
STDOUT
    end

  end
end
