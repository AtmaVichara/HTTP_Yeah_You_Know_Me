require 'socket'
require 'uri'
require_relative 'paths'
require_relative 'request_formatter'
require_relative 'game'

class Server

  def initialize(server)
    @server = server
    @formatter = RequestFormatter.new
    @game = Game.new
  end

  attr_reader :server, :port, :formatter, :game

  def run_server
    hello_counter = 0
    request_counter = 0
    loop do
      client = server.accept
      # create request lines
      request_lines = client_request(client)
      # create diagnostics using the request lines
      diagnostics = formatter.diagnostics(request_lines)
      # format the diagnostics for readability
      formatted_diagnostics = formatter.format_diagnostics(diagnostics)
      # create paths boolean
      path = Paths.new(diagnostics[:path])

      # conditional statememt to determine response and based on paths
      if path.hello?
        response = "Hello World (#{hello_counter})"
        hello_counter += 1
        request_counter += 1
      elsif path.root?
        response = "<pre>#{formatted_diagnostics.join("\r\n")}</pre>"
        request_counter += 1
      elsif path.date_time?
        response = "#{Time.now.strftime("%I %M:%p on %A, %B %e, %Y")}"
        request_counter += 1
      elsif path.shut_down?
        response = "Total requests: #{request_counter}"
      elsif path.word_search?
        response = "To search for a word, add '?word=' after word_search, then the word."
        if path.path.include?('=')
          split_path = path.path.split('=')
          if system_words.include?(split_path[1])
            response = "#{split_path[1].upcase} is a known word"
          else
            response = "#{split_path[1].upcase} is a not known word"
          end
        end
        request_counter += 1
      elsif path.start_game? && diagnostics[:verb] == "POST"
        response = "GOOD LUCK!!!!!"
      elsif path.game? && diagnostics[:verb] == "GET"
        response = game.start_game
      elsif path.game? && diagnostics[:verb] == "POST"
        game.read_guess(client, request_lines)
      end
      # create a format for the response
      output = format_output(response)
      # add the formattted response to the headers debuggin purposes
      header = headers(output)


      client.puts header
      client.puts output

      # puts header
      # puts formatted_diagnostics.join("\r\n")
      puts "\n"
      puts request_lines
      puts "\n"

      client.close
      break if path.shut_down?
    end
  end

  def listener(server)
    client = server.accept
    client
  end

  private

  def client_request(listener)
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

if __FILE__ == $0
  tcp_server = TCPServer.new(9292)
  server = Server.new(tcp_server)
  server.run_server
end
