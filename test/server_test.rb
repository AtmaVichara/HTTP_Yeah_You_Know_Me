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
  GAME              = "<html><head></head><body><pre>Amount of guesses so far: 1\r\nYour guess: \r\nYour guess was too low.\r\n<strong>TRY AGAIN!!</strong></pre></body></html>"
  FORBIDDEN         = "<html><head></head><body>OI!! Why are you searching for somthing that doesn't exist... Come on now.</body></html>"

  def test_root_body_returns_correct_value
    response = Faraday.get 'http://127.0.0.1:9292/'

    assert_equal ROOT_RESPONSE, response.body
    assert_equal 200, response.status
  end

  def test_hello_body_returns_correct_value
    response = Faraday.get "http://127.0.0.1:9292/hello"
    response2 = Faraday.get "http://127.0.0.1:9292/hello"

    assert_equal HELLO_RESPONSE, response.body
    assert_equal HELLO_INCREMENTER, response2.body
    assert_equal 200, response.status
    assert_equal 200, response2.status
  end


  def test_date_time_body_returns_correct_time
    response = Faraday.get "http://127.0.0.1:9292/datetime"

    assert_equal DATE_TIME, response.body
    assert_equal 200, response.status
  end

  def test_word_search_returns_correct_word
    response = Faraday.get "http://127.0.0.1:9292/word_search?word=something"

    assert_equal WORD_SEARCH, response.body
    assert_equal 200, response.status
  end

  def test_start_game_returns_correct_body
    response = Faraday.post "http://127.0.0.1:9292/start_game"

    assert_equal 301, response.status
    assert_equal "http://127.0.0.1:9292/game", response.headers[:location]
  end

  def test_game_takes_arguments_when_posted
    response = Faraday.post "http://127.0.0.1:9292/game"

    assert_equal 302, response.status
    assert_equal "http://127.0.0.1:9292/game", response.headers[:location]
  end

  def test_game_get_returns_correct_body
    response = Faraday.get "http://127.0.0.1:9292/game"

    assert_equal 200, response.status
    assert_equal GAME, response.body
  end

  def test_404_body_is_correct
    response = Faraday.get "http://127.0.0.1:9292/asdfas"

    assert_equal 404, response.status
    assert_equal FORBIDDEN, response.body
  end

  def test_shut_down_shuts_down
    skip
    response = Faraday.get "http://127.0.0.1:9292/shut_down"


    assert_equal 200, response.status
  end

  def test_force_error_works
    response = Faraday.get "http://127.0.0.1:9292/force_error"

    assert_equal 500, response.status
    assert_equal "<html><head></head><body>SYSTEMERROR!!</body></html>", response.body
  end
end
