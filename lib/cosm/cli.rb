require "cosm"
require "cosm/command"

class Cosm::CLI

  def self.start(*args)
    command = args.shift.strip rescue "help"
    Cosm::Command.load
    Cosm::Command.run(command, args)
  end

end
