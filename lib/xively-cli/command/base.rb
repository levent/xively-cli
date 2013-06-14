require "fileutils"
require "xively-cli/command"

class Xively::Command::Base

  def self.namespace
    self.to_s.split("::").last.downcase
  end

  attr_reader :args
  attr_reader :options

  def initialize(args=[], options={})
    @args = args
    @options = options
  end

protected

  def self.inherited(klass)
    unless klass == Xively::Command::Base
      help = extract_help_from_caller(caller.first)

      Xively::Command.register_namespace(
        :name => klass.namespace,
        :description => help.first
      )
    end
  end

  def self.method_added(method)
    return if self == Xively::Command::Base
    return if private_method_defined?(method)
    return if protected_method_defined?(method)

    help = extract_help_from_caller(caller.first)
    resolved_method = (method.to_s == "index") ? nil : method.to_s
    command = [ self.namespace, resolved_method ].compact.join(":")
    banner = extract_banner(help) || command

    Xively::Command.register_command(
      :klass       => self,
      :method      => method,
      :namespace   => self.namespace,
      :command     => command,
      :banner      => banner.strip,
      :help        => help.join("\n"),
      :summary     => extract_summary(help),
      :description => extract_description(help),
      :options     => extract_options(help)
    )
  end

  def self.alias_command(new, old)
    raise "no such command: #{old}" unless Xively::Command.commands[old]
    Xively::Command.command_aliases[new] = old
  end

  #
  # Parse the caller format and identify the file and line number as identified
  # in : http://www.ruby-doc.org/core/classes/Kernel.html#M001397.  This will
  # look for a colon followed by a digit as the delimiter.  The biggest
  # complication is windows paths, which have a color after the drive letter.
  # This regex will match paths as anything from the beginning to a colon
  # directly followed by a number (the line number).
  #
  def self.extract_help_from_caller(line)
    # pull out of the caller the information for the file path and line number
    if line =~ /^(.+?):(\d+)/
      extract_help($1, $2)
    else
      raise("unable to extract help from caller: #{line}")
    end
  end

  def self.extract_help(file, line_number)
    buffer = []
    lines = Xively::Command.files[file]

    (line_number.to_i-2).downto(0) do |i|
      line = lines[i]
      case line[0..0]
        when ""
        when "#"
          buffer.unshift(line[1..-1])
        else
          break
      end
    end

    buffer
  end

  def self.extract_banner(help)
    help.first
  end

  def self.extract_summary(help)
    extract_description(help).split("\n")[2].to_s.split("\n").first
  end

  def self.extract_description(help)
    help.reject do |line|
      line =~ /^\s+-(.+)#(.+)/
    end.join("\n")
  end

  def self.extract_options(help)
    help.select do |line|
      line =~ /^\s+-(.+)#(.+)/
    end.inject({}) do |hash, line|
      description = line.split("#", 2).last
      long  = line.match(/--([A-Za-z\- ]+)/)[1].strip
      short = line.match(/-([A-Za-z ])[ ,]/) && $1 && $1.strip
      hash.update(long.split(" ").first => { :desc => description, :short => short, :long => long })
    end
  end

  def current_command
    Xively::Command.current_command
  end

  def extract_option(key)
    options[key.dup.gsub('-','').to_sym]
  end

  def invalid_arguments
    Xively::Command.invalid_arguments
  end

  def shift_argument
    Xively::Command.shift_argument
  end

  def validate_arguments!
    Xively::Command.validate_arguments!
  end

  def escape(value)
    xively.escape(value)
  end
end

module Xively::Command
  unless const_defined?(:BaseWithApp)
    BaseWithApp = Base
  end
end
