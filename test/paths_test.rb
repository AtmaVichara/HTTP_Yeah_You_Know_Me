require 'minitest/autorun'
require 'minitest/pride'
require './lib/paths'

class PathsTest < Minitest::Test

  def test_root_is_true
    path = Paths.new("/")

    assert path.root?
    refute path.hello?
    refute path.word_search?
  end

  def test_hello_is_true
    path = Paths.new("/hello")

    assert path.hello?
    refute path.start_game?
    refute path.root?
  end

  def test_date_time_is_true
    path = Paths.new("/datetime")

    assert path.date_time?
    refute path.start_game?
    refute path.root?
  end

  def test_shut_down_is_true
    path = Paths.new("/shutdown")

    assert path.shut_down?
    refute path.start_game?
    refute path.root?
  end

  def test_word_search_is_true
    path = Paths.new("/word_search")

    assert path.word_search?
    refute path.start_game?
    refute path.root?
  end

  def test_start_game_is_true
    path = Paths.new("/start_game")

    assert path.start_game?
    refute path.word_search?
    refute path.root?
  end

  def test_game_is_true
    path = Paths.new("/game")

    assert path.game?
    refute path.start_game?
    refute path.root?
  end
end
