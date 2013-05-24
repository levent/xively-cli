require "xively/command/base"
require "xively/version"

# display version
#
class Xively::Command::Version < Xively::Command::Base

  # version
  #
  # show xively client version
  #
  #Example:
  #
  # $ xively version
  # v0.0.1
  #
  def index
    validate_arguments!

    puts(Xively::VERSION)
  end

end
