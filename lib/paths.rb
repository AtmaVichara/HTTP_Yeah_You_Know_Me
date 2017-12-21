class Paths

  attr_reader :path

  def initialize(path)
    @path = path
  end

  def root?
    path == "/"
  end

  def hello?
    path == "/hello"
  end

  def date_time?
    path == "/datetime"
  end

  def shut_down?
    path == "/shutdown"
  end

  def word_search?
    path.include?("word_search")
  end

  def start_game?
    path == "/start_game"
  end

  def game?
    path.start_with?("/game")
  end

  def not_found?
    !start_game? && !date_time? && !game? && !shut_down? && !word_search? && !root? && !hello?
  end
end
