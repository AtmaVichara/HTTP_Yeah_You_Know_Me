class RequestParser

  def request_parser(request)
    {
      verb: request.first.split(' ').first,
      path: request.first.split(' ')[1],
      protocol: request.first.split(' ')[2],
      host: request[1].split('')[0..14].join,
      port: request[1].split('')[-4..-1].join,
      origin: request[1].split('')[6..14].join,
      accept: request.select { |i| i.include?("Accept") }[0]
    }
  end

  def debug_info(request)
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

  def content_length(request)
    request[3].split(':')[1]
  end


end
