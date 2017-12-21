require "./lib/server"
require "pry"

server = Server.new(9292)
server.run
