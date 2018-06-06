# Using Kernel#require, we'd import this class into the global namespace.
# Using Kernel#import, we won't as everything is evaluated in a context
# of a name context object.
class PrivateClass
end

class Task < PrivateClass
end

class ScheduledTask < Task
end

# Here we use a different export name to verify that the class name doesn't get
# overriden (class_name.name reports Task resp. ScheduledTask rather than
# the underscored version).
exports._Task = Task
exports._ScheduledTask = ScheduledTask

