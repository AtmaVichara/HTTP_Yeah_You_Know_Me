require "./lib/server.rb"
require "./lib/request_formatter.rb"
require "./lib/paths.rb"
require "./lib/responses.rb"
require "./lib/game.rb"

server          = Server.new(9292)
tcp             = server.server
parser          = RequestParser.new
game            = Game.new
hello_counter   = 0
request_counter = 0

loop do
  client = tcp.accept
  request_lines = server.client_request(client)
  request_parsings = parser.request_parser(request_lines)
  debug_info = parser.debug_info(request_parsings)
  path = Paths.new(request_parsings[:path])
  responses = Responses.new(debug_info, request_parsings)
  request_counter += 1

  if path.hello?
    hello_counter += 1
    output = server.format_output(responses.hello(hello_counter))
    header = server.headers(output)
  elsif path.root?
    output = server.format_output(responses.root)
    header = server.headers(output)
  elsif path.date_time?
    output = server.format_output(responses.date_time)
    header = server.headers(output)
  elsif path.word_search?
    output = server.format_output(responses.word_search)
    header = server.headers(output)
  elsif path.shut_down?
    output = server.format_output(responses.shut_down(request_counter))
    header = server.headers(output)
  elsif path.start_game? && request_parsings[:verb] == "POST"
    output = server.format_output(responses.start_game)
    header = server.headers(output)
  elsif path.game? && request_parsings[:verb] == "GET"
    output = server.format_output(game.start_game)
    header = server.headers(output)
  elsif path.game? && request_parsings[:verb] == "POST"
    output = server.format_output(game.read_guess(client, request_lines))
    header = server.game_post_headers(output)
  end

  client.puts header
  client.puts output
  client.close

  puts "\n"
  puts debug_info
  puts "\n"

  
  break if path.shut_down?
end
