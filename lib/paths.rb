class Paths

  attr_reader :path

  def initialize(path)
    @path = path
  end

  def root?
    path == "/"
  end 

  def hello?
    @path == "/hello"
  end

  def date_time?
    path == "/datetime"
  end

  def shut_down?
    path == "/shutdown"
  end

end
