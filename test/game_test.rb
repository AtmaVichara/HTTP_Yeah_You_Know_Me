require "minitest/autorun"
require "minitest/pride"
require "./lib/game"

class GameTest < Minitest::Test

  def test_game_creates_random_number_between_1_to_100
    game = Game.new
    numbers = []
    100.times do |number|
      numbers << number
    end

    assert_includes numbers, game.number
  end

end
