require 'minitest/autorun'
require 'minitest/pride'
require './lib/server.rb'
require 'faraday'

class ServerTest < Minitest::Test

  attr_reader :server

  # def setup
  #   @server = Server.new(9292)
  # end
  #
  # def test_server_initiliazes_as_TCP_server
  #   assert_instance_of TCPServer, server.server
  # end

  def test_server_runs
    require 'pry'; binding.pry

    response = Faraday.get 'http://127.0.0.1:9292/'

  end

end
