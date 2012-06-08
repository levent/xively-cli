require "cosm/command/base"
require "cosm/version"

# display version
#
class Cosm::Command::Version < Cosm::Command::Base

  # version
  #
  # show cosm client version
  #
  #Example:
  #
  # $ cosm version
  # v0.0.1
  #
  def index
    validate_arguments!

    puts(Cosm::VERSION)
  end

end
