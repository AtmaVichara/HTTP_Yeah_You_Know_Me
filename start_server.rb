require "./lib/server.rb"

tcp_server = TCPServer.new(9292)
server = Server.new(tcp_server)

server.run_server

loop do
  client

end
