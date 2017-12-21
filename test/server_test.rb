require 'simplecov'
SimpleCov.start do
  add_filter "/test/"
end
require 'minitest/autorun'
require 'minitest/pride'
require './lib/server.rb'
require 'socket'
require 'faraday'
require 'pry'

class ServerTest < Minitest::Test

  ROOT_RESPONSE     = "<html><head></head><body><pre>Verb: GET\r\nPath: /\r\nProtocol: HTTP/1.1\r\nUser-Agent: Far\r\nPort: 13.1\r\nOrigin: gent: Far\r\nAccept-Encoding: gzip;q=1.0,deflate;q=0.6,identity;q=0.3</pre></body></html>"

  HELLO_RESPONSE    = "<html><head></head><body>Hello World (1)</body></html>"
  HELLO_INCREMENTER = "<html><head></head><body>Hello World (2)</body></html>"

  DATE_TIME         = "<html><head></head><body>#{Time.now.strftime("%I %M:%p on %A, %B %e, %Y")}</body></html>"

  WORD_SEARCH       = "<html><head></head><body>SOMETHING is a known word</body></html>"

  def test_root_body_returns_correct_value
    response = Faraday.get 'http://127.0.0.1:9292/'

    assert_equal ROOT_RESPONSE, response.body
  end

  def test_hello_body_returns_correct_value
    response = Faraday.get "http://127.0.0.1:9292/hello"
    response2 = Faraday.get "http://127.0.0.1:9292/hello"

    assert_equal HELLO_RESPONSE, response.body
    assert_equal HELLO_INCREMENTER, response2.body
  end


  def test_date_time_body_returns_correct_time
    response = Faraday.get "http://127.0.0.1:9292/datetime"

    assert_equal DATE_TIME, response.body
  end

  def test_word_search_returns_correct_word
    response = Faraday.get "http://127.0.0.1:9292/word_search?word=something"

    assert_equal WORD_SEARCH, response.body
  end

  def test_shut_down_returns_correct_body
    response = Faraday.get "http://127.0.0.1:9292/shutdown"

    binding.pry
  end
end
