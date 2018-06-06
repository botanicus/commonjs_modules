# Run with ./examples/runner.rb examples/file.rb

# Using Kernel#require, we'd import this class into the global namespace.
# Using Kernel#import, we won't, as everything is evaluated in a context
# of a name context object.
class PrivateClass
end

# Class inherits from Object, so no matter what we do, here all the puts
# and everything will be available again.
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
