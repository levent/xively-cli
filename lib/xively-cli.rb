require "xively-cli/command"

module Xively
  class CLI

    def self.start(*args)
      command = args.shift.strip rescue "help"
      Xively::Command.load
      Xively::Command.run(command, args)
    end

  end
end
