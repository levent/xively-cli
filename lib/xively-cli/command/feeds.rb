require 'xively-cli/command/base'
require 'xively-rb'

# Create a Xively feed
#
class Xively::Command::Feeds < Xively::Command::Base

  # feeds:create [TITLE]
  #
  # create a Xively feed
  #
  # -k, --key API_KEY     # your api key
  #
  #Examples:
  #
  # $ xively feeds:create "Home energy monitor" -k ABCD1234
  #
  def create
    title = shift_argument
    api_key = options[:key]
    validate_arguments!

    if title.nil?
      $stderr.puts "Please provide a title"
      exit(1)
    end

    if api_key.nil?
      $stderr.puts Xively::Command::Help.usage_for_command("feeds:create")
      exit(1)
    end

    puts "Creating feed \"#{title}\"..."

    feed = Xively::Feed.new
    feed.title = title

    response = Xively::Client.post('/v2/feeds.json', :headers => {'X-ApiKey' => api_key}, :body => feed.to_json)
    if response.code == 201
      puts "Your feed has been created at:"
      puts response.headers['location']
    end
  end

  alias_command "create", "feeds:create"
end
