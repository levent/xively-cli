require 'cosm/command/base'
require 'eventmachine'

# Subscribe to a datastream
#
class Cosm::Command::Subscribe < Cosm::Command::Base

  module CosmSocket
    attr_accessor :api_key, :feed_id, :datastream_id

    def initialize(args)
      @api_key = args[:key]
      @feed_id = args[:feed]
      @datastream_id = args[:datastream]
    end

    def post_init
      puts "Starting Cosm Socket Connection"
      subscribe = "{\"method\":\"subscribe\", \"resource\":\"/feeds/#{feed_id}/datastreams/#{datastream_id}\", \"headers\":{\"X-ApiKey\":\"#{api_key}\"}}"
      send_data subscribe
    end

    def receive_data(data)
      if STDOUT.isatty && ENV.has_key?("TERM")
        puts(colorize(data))
      else
        puts(data)
      end
      if data =~ /"status":40/
        close_connection
        exit(1)
      end
    end

    protected

    def colorize(string)
      string
    end
  end

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
    feed = options[:feed]
    datastream = options[:datastream]

    validate_arguments!

    unless api_key && feed && datastream
      puts Cosm::Command::Help.usage_for_command("subscribe")
      exit
    end

    EventMachine.run {
      EventMachine::connect 'api.cosm.com', 8081, CosmSocket, options
    }
  end

  alias_command "sub", "subscribe"

end

