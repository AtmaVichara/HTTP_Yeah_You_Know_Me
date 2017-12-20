require 'socket'
require_relative 'paths'
require_relative 'request_formatter'

class Server

  attr_reader :server, :port

  def initialize(port)
    @server = TCPServer.new(port)
  end

  def client_request(listener)
    request_lines = []
    while line = listener.gets and !line.chomp.empty?
      request_lines << line.chomp
    end
    request_lines
  end

  def headers(output)
    ["http/1.1 200 ok",
      "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
      "server: ruby",
      "content-type: text/html; charset=iso-8859-1",
      "content-length: #{output.length}\r\n\r\n"].join("\r\n")
  end

  def game_post_headers(output)
    ["http/1.1 302 found",
      "Location: http://127.0.0.1:9292/game",
      "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
      "server: ruby",
      "content-type: text/html; charset=iso-8859-1",
      "content-length: #{output.length}\r\n\r\n"].join("\r\n")
  end

  def format_output(response)
    "<html><head></head><body>#{response}</body></html>"
  end

end
