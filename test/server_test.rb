require 'minitest/autorun'
require 'minitest/pride'
require './lib/server.rb'
require 'faraday'

class ServerTest < Minitest::Test

  attr_reader :server

  def setup
    tcp_server = TCPServer.new(9292)
    @server = Server.new(tcp_server)
  end

  def test_server_initiliazes_as_TCP_server
    assert_instance_of TCPServer, server.server
  end

  def test_server_runs
    response = Faraday.get 'http://127.0.0.1:9292/hello'

    assert_equal "Hello World (0)", response.body
  end
end
