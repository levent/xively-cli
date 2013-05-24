# list commands and display help
#
class Xively::Command::Help < Xively::Command::Base

  PRIMARY_NAMESPACES = %w( subscribe )

  # help [COMMAND]
  #
  # list available commands or display help for a specific command
  #
  #Examples:
  #
  # $ xively help
  # Usage: xively COMMAND [--key API_KEY] [command-specific-options]
  #
  # Primary help topics, type "xively help TOPIC" for more details:
  #
  #   subscribe    #  subscribe to a datastream
  #   ...
  #
  def index
    if command = args.shift
      help_for_command(command)
    else
      help_for_root
    end
  end

  alias_command "-h", "help"
  alias_command "--help", "help"

  def self.usage_for_command(command)
    command = new.send(:commands)[command]
    "Usage: xively #{command[:help]}" if command
  end

private

  def commands_for_namespace(name)
    Xively::Command.commands.values.select do |command|
      command[:namespace] == name && command[:command] != name
    end
  end

  def namespaces
    namespaces = Xively::Command.namespaces
    namespaces.delete("app")
    namespaces
  end

  def commands
    Xively::Command.commands
  end

  def primary_namespaces
    PRIMARY_NAMESPACES.map { |name| namespaces[name] }.compact
  end

  def additional_namespaces
    (namespaces.values - primary_namespaces)
  end

  def summary_for_namespaces(namespaces)
    size = (namespaces.map { |n| n[:name] }).map { |i| i.to_s.length }.sort.last
    namespaces.sort_by {|namespace| namespace[:name]}.each do |namespace|
      name = namespace[:name]
      namespace[:description]
      puts "  %-#{size}s  # %s" % [ name, namespace[:description] ]
    end
  end

  def help_for_root
    puts "Usage: xively COMMAND [--key API_KEY] [command-specific-options]"
    puts
    puts "Primary help topics, type \"xively help TOPIC\" for more details:"
    puts
    summary_for_namespaces(primary_namespaces)
    puts
    puts "Additional topics:"
    puts
    summary_for_namespaces(additional_namespaces)
    puts
  end

  def help_for_namespace(name)
    namespace_commands = commands_for_namespace(name)

    unless namespace_commands.empty?
      size = (namespace_commands.map { |c| c[:banner] }).map { |i| i.to_s.length }.sort.last
      namespace_commands.sort_by { |c| c[:banner].to_s }.each do |command|
        next if command[:help] =~ /DEPRECATED/
        command[:summary]
        puts "  %-#{size}s  # %s" % [ command[:banner], command[:summary] ]
      end
    end
  end

  def help_for_command(name)
    if command_alias = Xively::Command.command_aliases[name]
      puts("Alias: #{name} is short for #{command_alias}")
      name = command_alias
    end
    if command = commands[name]
      puts "Usage: xively #{command[:banner]}"

      if command[:help].strip.length > 0
        puts command[:help].split("\n")[1..-1].join("\n")
      end
      puts
    end

    if commands_for_namespace(name).size > 0
      puts "Additional commands, type \"xively help COMMAND\" for more details:"
      puts
      help_for_namespace(name)
      puts
    elsif command.nil?
      puts "#{name} is not a xively command. See `xively help`."
    end
  end
end
