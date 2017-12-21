require 'socket'
require './lib/paths.rb'
require './lib/request_parser.rb'

class ServerInfo

  attr_reader :server, :port

  def client_request(listener)
    request_lines = []
    while line = listener.gets and !line.chomp.empty?
      request_lines << line.chomp
    end
    request_lines
  end

  def headers(status_code = "200", output)
    ["http/1.1 #{status_code} ok",
      "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
      "server: ruby",
      "content-type: text/html; charset=iso-8859-1",
      "content-length: #{output.length}\r\n\r\n"].join("\r\n")
  end

  def redirect_headers(status_code = "302", path, output)
    ["http/1.1 #{status_code} found",
      "Location: http://127.0.0.1:9292/#{path}",
      "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
      "server: ruby",
      "content-type: text/html; charset=iso-8859-1",
      "content-length: #{output.length}\r\n\r\n"].join("\r\n")
  end


  def format_output(response)
    "<html><head></head><body>#{response}</body></html>"
  end

end
