require 'socket'
tcp_server = TCPServer.new(9292)
client = tcp_server.accept
# count = 0
#
# loop {
#   count += 1
#   if client.gets
#     client.close
#     break
#   end
# }
# puts "Closed Connection"
# puts count


# Requesting the IO stream from the server
puts "Ready for a request"
puts "\n"
request_lines = []
while line = client.gets and !line.chomp.empty?
  request_lines << line.chomp
end

# We save the IO stream in a variable above and inspect it here
puts "Got this request:"
puts request_lines.inspect

puts "\n\n"

# Then the server sends a response back to the client.
puts "Sending response."
response = "<pre>" + request_lines.join("\n") + "</pre>"
output = "<html><head></head><body>#{response}</body></html>"
headers = ["http/1.1 200 ok",
          "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
          "server: ruby",
          "content-type: text/html; charset=iso-8859-1",
          "content-length: #{output.length}\r\n\r\n"].join("\r\n")

#
client.puts headers
client.puts output

puts ["Wrote this response:", headers, output].join("\n")
client.close
puts "\nResponse complete, exiting."
