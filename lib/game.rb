require './lib/request_formatter'

class Game

  attr_reader :number, :guess, :guess_count, :client, :request

  def initialize
    @number = rand(0..100)
    @guess = ""
    @guess_count = 0
    @request = RequestParser.new
  end

  def guessing_game_info
    [
      "Amount of guesses so far: #{guess_count}",
      "Your guess: #{guess}",
      guess_accuracy
    ].join("\r\n")
  end

  def guess_accuracy
    guess = @guess.to_i
    if guess > number
      "Your guess was too high!"
    elsif guess < number
      "Your guess was too low."
    elsif guess == number
      "Success!! You guessed correctly."
    end
  end

  def start_game
    "<p>
    #{guessing_game_info}
    </p>"
  end

  def read_guess(client, request_lines)
    @guess_count += 1
    bytes = request.content_length(request_lines)
    body = client.read(bytes.to_i) if !bytes.nil?
    @guess = body.split("\r\n")[3]
  end
end
