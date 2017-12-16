require 'socket'

def Socket

  def initialize(port)
    @server = TCPServer.new(port)
    @listener = server.accept
  end

  private
  attr_reader :server, :listener

  def client_request
    puts "Ready for a request"
    request_lines = []
    while line = client.gets and !line.chomp.empty?
      request_lines << line.chomp
    end
    request_lines
  end

  def run_server
    
  end

end
