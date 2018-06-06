#!/usr/bin/env ruby -Ilib -rimport
#
#exports.Task = Class.new do
  def initialize(name)
    @name = name
  end
end

exports.ScheduledTask = Class.new(exports.Task) do
  def schedule(time)
    # TODO ...
  end
end

(require 'pry'; binding.pry) if __FILE__ == $0
