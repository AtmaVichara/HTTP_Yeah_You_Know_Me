require 'socket'

class Server

  def initialize(port)
    @port = port
    @server = TCPServer.new(@port)
  end

  attr_reader :server, :listener, :port

  def run_server
    counter = 0
    loop do
      client = server.accept
      request_lines = client_request(client)
      formatted_request = format_request(request_lines)
      puts "Starting Up Server"
      formatted_request = formatted_request.map do |request|
        format_paragraph(request)
      end.join(" ")
      response = "Hello World (#{counter}) <p>#{formatted_request}</p>"
      output = format_output(response)
      header = headers(output)
      client.puts header
      client.puts output
      client.close
      counter += 1
    end
  end

  private

  def client_request(listener)
    puts "Ready for a request"
    request_lines = []
    while line = listener.gets and !line.chomp.empty?
      request_lines << line.chomp
    end
    request_lines
  end

  def format_request(request)
    [
      "Verb: #{request.first.split(' ').first}",
      "Path: #{request.first.split(' ')[1]}",
      "Protocol: #{request.first.split(' ')[2]}",
      "#{request[1].split('')[0..14].join}",
      "Port: #{request[1].split('')[-4..-1].join}",
      "Origin: #{request[1].split('')[6..14].join}",
      "#{request[6]}"
    ]
  end

  def format_paragraph(paragraphs)
    "<p> #{paragraphs} </p>"
  end

  def headers(output)
    ["http/1.1 200 ok",
      "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
      "server: ruby",
      "content-type: text/html; charset=iso-8859-1",
      "content-length: #{output.length}\r\n\r\n"].join("\r\n")
  end

  def format_output(response)
    "<html><head></head><body>#{response}</body></html>"
  end

end

if __FILE__ == $0
  server = Server.new(9292)
  server.run_server

end
