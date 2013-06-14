require "spec_helper"
require "xively-cli/command/subscribe"

describe Xively::Command::Subscribe do
  before do
    stub_tcp_socket
  end

  describe "subscribe" do
    before do
      @mock_sock = MockTCPSocket.new
    end

    context "datastream" do
      it "runs with options" do
        TCPSocket.should_receive(:new).with('api.xively.com', 8081).and_return @mock_sock
        @mock_sock.should_receive(:puts).with("{\"method\":\"subscribe\", \"resource\":\"/feeds/504/datastreams/0\", \"headers\":{\"X-ApiKey\":\"1234\"}}")
        @mock_sock.should_receive(:gets).and_return('stream of data', 'more dataz', nil)
        stderr, stdout = execute("subscribe -k 1234 -f 504 -d 0")
        stdout.should =~ /stream of data/
          stdout.should =~ /more dataz/
      end
    end

    context "feed" do
      it "runs with options" do
        TCPSocket.should_receive(:new).with('api.xively.com', 8081).and_return @mock_sock
        @mock_sock.should_receive(:puts).with("{\"method\":\"subscribe\", \"resource\":\"/feeds/504\", \"headers\":{\"X-ApiKey\":\"1234\"}}")
        @mock_sock.should_receive(:gets).and_return('stream of data', 'more dataz', nil)
        stderr, stdout = execute("subscribe -k 1234 -f 504")
        stdout.should =~ /stream of data/
          stdout.should =~ /more dataz/
      end
    end

    it "should close socket if auth fails" do
      TCPSocket.should_receive(:new).with('api.xively.com', 8081).and_return @mock_sock
      @mock_sock.should_receive(:puts).with("{\"method\":\"subscribe\", \"resource\":\"/feeds/504/datastreams/0\", \"headers\":{\"X-ApiKey\":\"1234\"}}")
      @mock_sock.should_receive(:gets).and_return("\"status\":403")
      @mock_sock.should_receive(:close)
      stderr, stdout = execute("subscribe -k 1234 -f 504 -d 0")
    end

    it "should close socket if interrupted (Ctrl-c)" do
      begin
        TCPSocket.should_receive(:new).with('api.xively.com', 8081).and_return @mock_sock
        @mock_sock.should_receive(:puts).with("{\"method\":\"subscribe\", \"resource\":\"/feeds/504/datastreams/0\", \"headers\":{\"X-ApiKey\":\"1234\"}}")
        @mock_sock.should_receive(:gets).and_raise(Interrupt)
        @mock_sock.should_receive(:close)
        stderr, stdout = execute("subscribe -k 1234 -f 504 -d 0")
        stdout.should =~ /Closing connection/
      rescue Interrupt
      end
    end

    it "should require all the options flags to be set" do
      stderr, stdout = execute("subscribe -k 1234 -d 0")
      stderr.should =~ /Usage: xively  subscribe/
      stderr.should =~ /tcp/
    end
  end

end
