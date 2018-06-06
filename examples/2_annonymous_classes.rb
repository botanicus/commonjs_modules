#!/usr/bin/env ruby -Ilib -rimport

# Annonymous classes should either use the explicit export or define a name.
exports.Task = Class.new do
  def initialize(name)
    @name = name
  end
end

exports.ScheduledTask = Class.new(exports.Task) do
  def schedule(time)
  end
end

export Class.new(exports.Task) do
  def self.name
    'ScheduledTask_II'
  end

  def schedule(time)
  end
end

(require 'pry'; binding.pry) if __FILE__ == $0
