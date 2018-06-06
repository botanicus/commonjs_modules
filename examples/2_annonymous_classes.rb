#!/usr/bin/env ruby -Ilib -rimport

if __FILE__ == $0
  def exports
    @exports ||= Imports::Export.new(__FILE__)
  end

  include Imports::DSL
end

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

export ScheduledTask_II: Class.new(exports.Task) do
  def schedule(time)
  end
end

(require 'pry'; binding.pry) if __FILE__ == $0
