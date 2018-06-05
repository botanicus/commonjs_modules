exports.language = "Ruby"
exports.VERSION_ = "0.0.1"

def exports.say_hello
  return "Hello World!"
end

exports.Task = Class.new do
  def initialize(name)
    @name = name
  end
end
