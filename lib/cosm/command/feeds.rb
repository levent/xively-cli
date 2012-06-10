require 'cosm/command/base'
require 'cosm-rb'

# Create a Cosm feed
#
class Cosm::Command::Feeds < Cosm::Command::Base

  # feeds:create [TITLE]
  #
  # create a Cosm feed
  #
  # -k, --key API_KEY     # your api key
  #
  #Examples:
  #
  # $ cosm feeds:create "Home energy monitor" -k ABCD1234
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
      $stderr.puts Cosm::Command::Help.usage_for_command("feeds:create")
      exit(1)
    end

    puts "Creating feed \"#{title}\"..."

    feed = Cosm::Feed.new
    feed.title = title

    response = Cosm::Client.post('/v2/feeds.json', :headers => {'X-ApiKey' => api_key}, :body => feed.to_json)
    if response.code == 201
      puts "Your feed has been created at:"
      puts response.headers['location']
    end
  end

  alias_command "create", "feeds:create"
end
