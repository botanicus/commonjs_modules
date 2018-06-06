# Using Kernel#require, we'd import this class into the global namespace.
# Using Kernel#import, we won't as everything is evaluated in a context
# of a name context object.
class PrivateClass
end

class TaskList < PrivateClass
end

class ScheduledTaskList < TaskList
end

# Here we use a different export name to verify that the class name doesn't get
# overriden (class_name.name reports TaskList resp. ScheduledTaskList rather than
# the underscored version).
exports._TaskList = TaskList
exports._ScheduledTaskList = ScheduledTaskList

