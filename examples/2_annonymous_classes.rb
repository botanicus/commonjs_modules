#!/usr/bin/env ruby -Ilib -rimport

# Simulate exports, so we can conveniently run this file to get PRY prompt.
# NOTE that there is one significant difference: the top-level namespace
# is an instance of Object rather than of Imports::Context!
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
