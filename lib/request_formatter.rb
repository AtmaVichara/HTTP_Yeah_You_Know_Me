class RequestFormatter

  def diagnostics(request)
    {
      verb: request.first.split(' ').first,
      path: request.first.split(' ')[1],
      protocol: request.first.split(' ')[2],
      host: request[1].split('')[0..14].join,
      port: request[1].split('')[-4..-1].join,
      origin: request[1].split('')[6..14].join,
      accept: request[6].split(":")[1]
    }
  end

  def format_diagnostics(request)
    [
      "Verb: #{request[:verb]}",
      "Path: #{request[:path]}",
      "Protocol: #{request[:protocol]}",
      "#{request[:host]}",
      "Port: #{request[:port]}",
      "Origin: #{request[:origin]}",
      "Accept:#{request[:accept]}"
    ]
  end

  def content_length(request)
    request[3].split(':')[1]
  end


end
