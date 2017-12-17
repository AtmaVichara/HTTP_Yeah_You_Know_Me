require 'socket'
require_relative 'paths'


class Server

  def initialize(port)
    @server = TCPServer.new(port)
  end

  attr_reader :server, :listener, :port

  def run_server
    counter = 0
    loop do
      client = server.accept
      request_lines = client_request(client)
      diagnotistics = diagnotistics(request_lines)
      formatted_diagnostics = format_diagnostics(diagnotistics)
      paragraph_request = formatted_diagnostics.map do |diagnostic|
        format_paragraph(diagnostic)
      end.join(" ")

      puts "Starting Up Server"
      response = "Hello World (#{counter}) <p>#{paragraph_request}</p>"
      output = format_output(response)
      header = headers(output)
      client.puts header
      client.puts output

      puts header
      puts formatted_diagnostics.join("\r\n")
      puts "\n"

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

  def format_diagnostics(request)
    [
      "Verb: #{request[:verb]}",
      "Path: #{request[:path]}",
      "Protocol: #{request[:protocol]}",
      "#{request[:host]}",
      "Port: #{request[:port]}",
      "Origin: #{request[:origin]}",
      "#{request[:accept]}"
    ]
  end

  def diagnotistics(request)
    {
      verb: request.first.split(' ').first,
      path: request.first.split(' ')[1],
      protocol: request.first.split(' ')[2],
      host: request[1].split('')[0..14].join,
      port: request[1].split('')[-4..-1].join,
      origin: request[1].split('')[6..14].join,
      accept: request[6]
    }
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
