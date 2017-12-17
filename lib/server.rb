require 'socket'
require_relative 'paths'

class Server

  def initialize(port)
    @server = TCPServer.new(port)
  end

  attr_reader :server, :listener, :port

  def run_server
    hello_counter = 0
    request_counter = 0
    loop do
      client = server.accept
      request_lines = client_request(client)
      diagnostics = diagnostics(request_lines)
      path = Paths.new(diagnostics[:path])
      formatted_diagnostics = format_diagnostics(diagnostics)
      paragraph_request = formatted_diagnostics.map do |diagnostic|
        format_paragraph(diagnostic)
      end.join(" ")

      if path.hello?
        response = "Hello World (#{hello_counter})"
        hello_counter += 1
        request_counter += 1
      elsif path.root?
        response = "<h> <strong>Diagnostics</strong> </h> #{paragraph_request}"
        request_counter += 1
      elsif path.date_time?
        response = "#{Time.now.strftime("%I %M:%p on %A, %B %e, %Y")}"
        request_counter += 1
      elsif path.shut_down?
        response = "Total requests: #{request_counter}"
      elsif path.word_search?
        response = "To search for a word, add '?' after word_search, then the word."
        if path.path.include?('?')
          split_path = path.path.split('?')
          if system_words.include?(split_path[1])
            response = "#{split_path[1].upcase} is a known word"
          else
            response = "#{split_path[1].upcase} is a not known word"
          end
        end
        request_counter += 1
      end

      puts "Starting Up Server"
      output = format_output(response)
      header = headers(output)
      client.puts header
      client.puts output

      puts header
      puts formatted_diagnostics.join("\r\n")
      puts "\n"

      client.close
      break if path.shut_down?
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

  def system_words
    words = File.readlines("/usr/share/dict/words")
    words = words.map { |word| word.chomp }
    words
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

  def diagnostics(request)
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
