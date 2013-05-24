require 'xively/command/base'
require 'socket'

# Subscribe to a feed or datastream via the Xively Socket Server
#
class Xively::Command::Subscribe < Xively::Command::Base

  # subscribe
  #
  # connect to a tcp socket for a feed or datastream
  #
  # -k, --key API_KEY        # your api key
  # -f, --feed FEED          # the feed id
  # -d, --datastream DATASTREAM  # the datastream id (optional)
  #
  #Example:
  #
  # $ xively subscribe -k ABCD1234 -f 504 -d 0 # subscribe to datastream
  # $ xively subscribe -k ABCD1234 -f 504 # subscribe to feed
  #
  def index
    api_key = options[:key]
    feed_id = options[:feed]
    datastream_id = options[:datastream]

    validate_arguments!

    unless api_key && feed_id
      $stderr.puts Xively::Command::Help.usage_for_command("subscribe")
      exit(1)
    end

    resource = "/feeds/#{feed_id}"
    resource += "/datastreams/#{datastream_id}" if datastream_id

    puts "Subscribing to updates for #{resource}"

    subscribe = "{\"method\":\"subscribe\", \"resource\":\"#{resource}\", \"headers\":{\"X-ApiKey\":\"#{api_key}\"}}"
    s = TCPSocket.new 'api.xively.com', 8081
    s.puts subscribe
    while line = s.gets
      parse_data(line, s)
    end
    s.close

    puts "Connection closed"

    # EventMachine.run {
    #   EventMachine::connect 'api.xively.com', 8081, XivelySocket, options
    # }
  rescue Interrupt => e
    puts "Closing connection"
    s.close
    raise e
  end

  alias_command "sub", "subscribe"

  protected

  def parse_data(string, socket)
    puts(string)
    if string =~ /"status":40/
      socket.close
      exit(1)
    end
  end

end

