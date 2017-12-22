require 'simplecov'
SimpleCov.start do
  add_filter "/test/"
end
require 'minitest/autorun'
require 'minitest/pride'
require './lib/server_info'

class ServerInfoTest < Minitest::Test

  REDIRECT_HEADERS = "http/1.1 404\r\nLocation: http://127.0.0.1:9292/hello\r\ndate: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}\r\nserver: ruby\r\ncontent-type: text/html; charset=iso-8859-1\r\ncontent-length: 9\r\n\r\n"
  HEADERS          = "http/1.1 404 ok\r\ndate: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}\r\nserver: ruby\r\ncontent-type: text/html; charset=iso-8859-1\r\ncontent-length: 9\r\n\r\n"


  def test_format_output_formats_response_in_html
    server_info = ServerInfo.new
    response = "How it do?"

    assert_equal "<html><head></head><body>How it do?</body></html>",
    server_info.format_output(response)
  end

  def test_headers_is_formatted_correctly
    server_info = ServerInfo.new
    output = 'this is 9'
    status = 404

    assert_equal HEADERS, server_info.headers(status, output)
  end

  def test_redirect_headers_formats_correctly
    server_info = ServerInfo.new
    output = 'this is 9'
    status = 404
    path = 'hello'

    assert_equal REDIRECT_HEADERS, server_info.redirect_headers(status, path, output)
  end
end
