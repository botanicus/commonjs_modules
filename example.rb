exports.language = "Ruby"
exports.VERSION_ = "0.0.1"

def exports.say_hello
  return "Hello World!"
end

exports.Task = Class.new do
  # TODO: 05/06/2018 Do this automatically.
  def self.inspect
    'Task'
  end

  def initialize(name)
    @name = name
  end
end
