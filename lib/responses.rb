require_relative 'paths'
require_relative 'request_formatter'

class Responses

  attr_reader :hello_counter,
              :request_counter,
              :formatted_diagnostics,
              :path,
              :diagnostics

  attr_accessor :response

  def initialize(formatted_diagnostics, diagnostics)
    @diagnostics = diagnostics
    @path = Paths.new(diagnostics[:path])
    @formatted_diagnostics = formatted_diagnostics
    @hello_counter = 0
    @request_counter = 0
    @response = ""
  end

  def root_response
    @request_counter += 1
    response = "<pre>#{formatted_diagnostics.join("\r\n")}</pre>"
  end

  def hello_response
    @hello_counter += 1
    @request_counter += 1
    response = "Hello World (#{hello_counter})"
  end

  def date_time_response
    @request_counter += 1
    response = "#{Time.now.strftime("%I %M:%p on %A, %B %e, %Y")}"
  end

  def shut_down_response
    @request_counter += 1
    response = "Total requests: #{@request_counter}"
  end

  def word_search_response
    @request_counter += 1
    response = "To search for a word, add '?' after word_search, then the word."
    if path.path.include?('?')
      split_path = path.path.split('?')
      if system_words.include?(split_path[1])
        response = "#{split_path[1].upcase} is a known word"
      else
        response = "#{split_path[1].upcase} is a not known word"
      end
    end
  end



    # def paths_request
    #   case path
    #   when path.root?
    #     @response = "<pre>#{formatted_diagnostics.join("\r\n")}</pre>"
    #   when path.hello?
    #     @response = "Hello World (#{hello_counter})"
    #     hello_counter += 1
    #     request_counter += 1
    #   when path.date_time?
    #     @response = "#{Time.now.strftime("%I %M:%p on %A, %B %e, %Y")}"
    #     request_counter += 1
    #   when path.word_search?
    #     @response = "To search for a word, add '?' after word_search, then the word."
    #     if path.path.include?('?')
    #       split_path = path.path.split('?')
    #       if system_words.include?(split_path[1])
    #         @response = "#{split_path[1].upcase} is a known word"
    #       else
    #         @response = "#{split_path[1].upcase} is a not known word"
    #       end
    #     end
    #     request_counter += 1
    #   when path.start_game? && diagnostics[:verb] == "POST"
    #     @response = "GOOD LUCK!!!!!"
    #   when path.game? && diagnostics[:verb] == "GET"
    #     @response = ""
    #   end
    # end
    #
    #

end
