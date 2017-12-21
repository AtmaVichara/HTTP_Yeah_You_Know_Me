require "minitest/autorun"
require "minitest/pride"
require "./lib/responses"


class ResponsesTest < Minitest::Test

  attr_reader :responses, :hello_counter

  def setup
    @responses = Responses.new(["ello", "there"], {path: "path=something"})
    @hello_counter = 100
  end

  def test_root_returns_root_with_variable
    assert_equal "<pre>ello\r\nthere</pre>", responses.root
  end

  def test_hello_counter_returns_correct_variable
    assert_equal "Hello World (100)", responses.hello(hello_counter)
  end

  def test_date_time_returns_correct_time_format
    assert_equal Time.now.strftime("%I %M:%p on %A, %B %e, %Y"), responses.date_time
  end

  def test_word_search_returns_something_is_a_known_word
    assert_equal "SOMETHING is a known word", responses.word_search
  end

  def test_word_search_returns_asdfae_is_not_a_known_word
    new_response = Responses.new(["eeeyyy", "what it do"], {path: "path=asdfae"})

    assert_equal "ASDFAE is not a known word", new_response.word_search
  end

  def test_start_game_returns_good_luck
    assert_equal "Good Luck!!!", responses.start_game
  end


  def test_not_found_returns_correct_string
    assert_equal "OI!! Why are you searching for somthing that doesn't exist... Come on now.",
    responses.not_found
  end

  def test_server_error_returns_system_error
    assert_equal "SYSTEMERROR!!", responses.server_error
  end
end
