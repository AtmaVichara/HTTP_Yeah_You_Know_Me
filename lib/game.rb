require './lib/request_parser'

class Game

  attr_reader :number, :guess, :guess_count, :client, :request

  def initialize
    @number = rand(0..100)
    @guess = ""
    @guess_count = 0
    @request = RequestParser.new
  end

  def guessing_game_info
    ["Amount of guesses so far: #{guess_count}",
      "Your guess: #{guess}",
      guess_accuracy
    ].join("\r\n")
  end

  def guess_accuracy
    guess = @guess.to_i
    if guess > number
      "Your guess was too high!\r\n<strong>TRY AGAIN!!!</strong>"
    elsif guess < number
      "Your guess was too low.\r\n<strong>TRY AGAIN!!</strong>"
    elsif guess == number
      "SUCCEYESSS!! You guessed correctly."
    end
  end

  def start_game
    "<pre>#{guessing_game_info}</pre>"
  end

  def read_guess(client, request_lines)
    @guess_count += 1
    bytes = request.content_length(request_lines)
    body = client.read(bytes.to_i) if !bytes.nil?
    @guess = body.split("\r\n")[3]
  end
end
