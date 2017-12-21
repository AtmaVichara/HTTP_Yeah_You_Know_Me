require 'minitest/autorun'
require 'minitest/pride'
require './lib/request_parser.rb'


class RequestParserTest < Minitest::Test
  REQUEST_LINES       = ["GET / HTTP/1.1",
                         "Host: 127.0.0.1:9292",
                         "Connection: keep-alive",
                         "Cache-Control: no-cache",
                         "Content-Type: text/plain",
                         "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.84 Safari/537.36",
                         "Postman-Token: 9c8fb4f3-b7c4-4887-0281-c8b52749bcf3",
                         "Accept: */*",
                         "Accept-Encoding: gzip, deflate, br",
                         "Accept-Language: en-US,en;q=0.9"]

  REQUEST_POST_LINES  = ["POST /game HTTP/1.1",
                         "Host: 127.0.0.1:9292",
                         "Connection: keep-alive",
                         "Content-Length: 139",
                         "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.84 Safari/537.36",
                         "Cache-Control: no-cache",
                         "Origin: chrome-extension://fhbjgbiflinjbdggehcddcbncdddomop",
                         "Postman-Token: 4bbdb4df-bc0e-4ed6-47a8-66f3c61fcaeb",
                         "Content-Type: text/plain",
                         "Accept: */*",
                         "Accept-Encoding: gzip, deflate, br",
                         "Accept-Language: en-US,en;q=0.9"]

  DEBUG_INFO          = ["Verb: GET",
                         "Path: /",
                         "Protocol: HTTP/1.1",
                         "Host: 127.0.0.1",
                         "Port: 9292",
                         "Origin: 127.0.0.1",
                         "Accept: */*"]

  REQUEST_PARSINGS    = {:verb=>"GET",
                         :path=>"/",
                         :protocol=>"HTTP/1.1",
                         :host=>"Host: 127.0.0.1",
                         :port=>"9292",
                         :origin=>"127.0.0.1",
                         :accept=>"Accept: */*"}


  def test_request_parser_parses_request_into_hash
    request_parsing = RequestParser.new

    assert_equal REQUEST_PARSINGS, request_parsing.request_parser(REQUEST_LINES)
  end

  def test_debug_info_formats_parsed_data
    request_parsing = RequestParser.new
    request_parsings = request_parsing.request_parser(REQUEST_LINES)

    assert_equal DEBUG_INFO, request_parsing.debug_info(request_parsings)
  end

  def test_content_length_returns_content_length_from_client_request
    request_parsing = RequestParser.new

    assert_equal 139, request_parsing.content_length(REQUEST_POST_LINES).to_i
  end
end
