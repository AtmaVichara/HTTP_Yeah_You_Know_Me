require "./lib/paths.rb"
require "./lib/request_formatter.rb"
require "./lib/game.rb"

class Responses

  attr_reader   :hello_counter,
                :request_counter,
                :debug_info,
                :path,
                :request_parser

  attr_accessor :response

  def initialize(debug_info, path)
    @path                  = path
    @debug_info            = debug_info
  end

  def root
    "<pre>#{debug_info.join("\r\n")}</pre>"
  end

  def hello(counter)
    "Hello World (#{counter})"
  end

  def date_time
    "#{Time.now.strftime("%I %M:%p on %A, %B %e, %Y")}"
  end

  def shut_down(request_counter)
    "Total requests: #{request_counter}"
  end

  def word_search
    split_path = path[:path].split('=')
    if system_words.include?(split_path[1])
      "#{split_path[1].upcase} is a known word"
    else
      "#{split_path[1].upcase} is not a known word"
    end
  end

  def system_words
    words = File.readlines("/usr/share/dict/words")
    words = words.map { |word| word.chomp }
    words
  end

  def start_game
    Game.new
    "Good Luck!!!"
  end


end
