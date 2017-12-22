require "minitest/autorun"
require "minitest/pride"
require "./lib/game"

class GameTest < Minitest::Test

  attr_reader :number,
              :guess,
              :wrong_guess,
              :high,
              :low

  def setup
    @guess       = 13
    @number      = 13
    @high        = 45
    @low         = 2
  end

  TOO_HIGH = "Your guess was too high!\r\n<strong>TRY AGAIN!!!</strong>"
  TOO_LOW  = "Your guess was too low.\r\n<strong>TRY AGAIN!!</strong>"
  GAME_INFO = ["Amount of guesses so far: 0",
               "Your guess: 2",
               TOO_LOW].join("\r\n")

  def test_game_creates_random_number_between_1_to_100
    game = Game.new
    numbers = []
    100.times do |number|
      numbers << number
    end

    assert_includes numbers, game.number
  end

  def test_guess_returns_SUCCESS
    game = Game.new
    game.guess  = guess
    game.number = number

    assert_equal "SUCCEYESSS!! You guessed correctly.", game.guess_accuracy
  end

  def test_guess_returns_too_high
    game = Game.new
    game.guess  = high
    game.number = number

    assert_equal TOO_HIGH, game.guess_accuracy
  end

  def test_guess_returns_too_low
    game = Game.new
    game.guess  = low
    game.number = number

    assert_equal TOO_LOW, game.guess_accuracy
  end

  def test_guess_info_returns_correct_format
    game = Game.new
    game.guess  = low
    game.number = number

    assert_equal TOO_LOW, game.guess_accuracy
    assert_equal GAME_INFO, game.guessing_game_info
  end

  def test_start_game_returns_correct_html_response
    game = Game.new
    game.guess  = low
    game.number = number

    assert_equal TOO_LOW, game.guess_accuracy
    assert_equal GAME_INFO, game.guessing_game_info
    assert_equal "<p>#{GAME_INFO}</p>", game.start_game
  end

end
