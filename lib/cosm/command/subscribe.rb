require 'cosm/command/base'
require 'socket'

# Subscribe to a datastream
#
class Cosm::Command::Subscribe < Cosm::Command::Base

  # subscribe
  #
  # connect to a tcp socket for a datastream
  #
  # -k, --key API_KEY        # your api key
  # -f, --feed FEED          # the feed id
  # -d, --datastream DATASTREAM  # the datastream id
  #
  #Example:
  #
  # $ cosm subscribe -k ABCD1234 -f 504 -d 0
  #
  def index
    api_key = options[:key]
    feed_id = options[:feed]
    datastream_id = options[:datastream]

    validate_arguments!

    unless api_key && feed_id && datastream_id
      puts Cosm::Command::Help.usage_for_command("subscribe")
      exit(1)
    end

    subscribe = "{\"method\":\"subscribe\", \"resource\":\"/feeds/#{feed_id}/datastreams/#{datastream_id}\", \"headers\":{\"X-ApiKey\":\"#{api_key}\"}}"
    s = TCPSocket.new 'api.cosm.com', 8081
    s.puts subscribe
    while line = s.gets
      parse_data(line, s)
    end
    s.close

    # EventMachine.run {
    #   EventMachine::connect 'api.cosm.com', 8081, CosmSocket, options
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

