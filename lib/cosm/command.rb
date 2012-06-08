require 'cosm/version'
require "optparse"

module Cosm
  module Command
    class CommandFailed  < RuntimeError; end

    def self.load
      Dir[File.join(File.dirname(__FILE__), "command", "*.rb")].each do |file|
        require file
      end
    end

    def self.commands
      @@commands ||= {}
    end

    def self.command_aliases
      @@command_aliases ||= {}
    end

    def self.files
      @@files ||= Hash.new {|hash,key| hash[key] = File.readlines(key).map {|line| line.strip}}
    end

    def self.namespaces
      @@namespaces ||= {}
    end

    def self.register_command(command)
      commands[command[:command]] = command
    end

    def self.register_namespace(namespace)
      namespaces[namespace[:name]] = namespace
    end

    def self.current_command
      @current_command
    end

    def self.current_command=(new_current_command)
      @current_command = new_current_command
    end

    def self.global_options
      @global_options ||= []
    end

    def self.invalid_arguments
      @invalid_arguments
    end

    def self.shift_argument
      @invalid_arguments.shift.downcase rescue nil
    end

    def self.validate_arguments!
      unless invalid_arguments.empty?
        arguments = invalid_arguments.map {|arg| "\"#{arg}\""}
        if arguments.length == 1
          message = "Invalid argument: #{arguments.first}"
        elsif arguments.length > 1
          message = "Invalid arguments: "
          message << arguments[0...-1].join(", ")
          message << " and "
          message << arguments[-1]
        end
        $stderr.puts(message)
        run(current_command, ["--help"])
        exit(1)
      end
    end

    def self.warnings
      @warnings ||= []
    end

    def self.display_warnings
      unless warnings.empty?
        $stderr.puts(warnings.map {|warning| " !    #{warning}"}.join("\n"))
      end
    end

    def self.global_option(name, *args, &blk)
      global_options << { :name => name, :args => args, :proc => blk }
    end

    global_option :key, "--key API_KEY", "-k"
    global_option :help,    "--help", "-h"

    def self.prepare_run(cmd, args=[])
      command = parse(cmd)

      unless command
        if %w( -v --version ).include?(cmd)
          command = parse('version')
        else
          $stderr.puts(["`#{cmd}` is not a cosm command.", "See `cosm help` for a list of available commands."].join("\n"))
          exit(1)
        end
      end

      @current_command = cmd

      opts = {}
      invalid_options = []

      parser = OptionParser.new do |parser|
        # overwrite OptionParsers Officious['version'] to avoid conflicts
        # see: https://github.com/ruby/ruby/blob/trunk/lib/optparse.rb#L814
        parser.on("--version") do |value|
          invalid_options << "--version"
        end
        global_options.each do |global_option|
          parser.on(*global_option[:args]) do |value|
            global_option[:proc].call(value) if global_option[:proc]
            opts[global_option[:name]] = value
          end
        end
        command[:options].each do |name, option|
          parser.on("-#{option[:short]}", "--#{option[:long]}", option[:desc]) do |value|
            opts[name.gsub("-", "_").to_sym] = value
          end
        end
      end

      begin
        parser.order!(args) do |nonopt|
          invalid_options << nonopt
        end
      rescue OptionParser::InvalidOption => ex
        invalid_options << ex.args.first
        retry
      end

      if opts[:help]
        args.unshift cmd unless cmd =~ /^-.*/
        cmd = "help"
        command = parse(cmd)
      end

      args.concat(invalid_options)

      @current_args = args
      @current_options = opts
      @invalid_arguments = invalid_options

      [ command[:klass].new(args.dup, opts.dup), command[:method] ]
    end

    def self.run(cmd, arguments=[])
      object, method = prepare_run(cmd, arguments.dup)
      object.send(method)
    rescue CommandFailed => e
      $stderr.puts e.message
    rescue OptionParser::ParseError
      commands[cmd] ? run("help", [cmd]) : run("help")
    ensure
      display_warnings
    end

    def self.parse(cmd)
      commands[cmd] || commands[command_aliases[cmd]]
    end

  end
end
