# frozen_string_literal: true

# Run with ./examples/runner.rb examples/file.rb

privateClass = Class.new do
  def initialize(name)
    @name = name
  end
end

exports.Task = Class.new(privateClass) do
  def schedule
    :from_task
  end
end

export ScheduledTask: Class.new(exports.Task) {
  def schedule
    :from_scheduled_task
  end
}
