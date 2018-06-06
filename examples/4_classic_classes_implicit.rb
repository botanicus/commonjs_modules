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

# Using Kernel#require, we'd import this class into the global namespace.
# Using Kernel#import, we won't as everything is evaluated in a context
# of a name context object.
class PrivateClass
end

class Task < PrivateClass
  def initialize(name)
    @name = name
  end
end

class ScheduledTask < Task
end

# Here we use a different export name to verify that the class name doesn't get
# overriden (class_name.name reports Task resp. ScheduledTask rather than
# the underscored version).
export _Task: Task, _ScheduledTask: ScheduledTask

(require 'pry'; binding.pry) if __FILE__ == $0
