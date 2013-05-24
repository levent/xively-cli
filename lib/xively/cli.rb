require "xively"
require "xively/command"

class Xively::CLI

  def self.start(*args)
    command = args.shift.strip rescue "help"
    Xively::Command.load
    Xively::Command.run(command, args)
  end

end
