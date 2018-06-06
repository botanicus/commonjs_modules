# Run with ./examples/runner.rb examples/file.rb

# Assigning to a constant will make the variable available within classes.
# FIXME: 06/06/2018 relative paths don't work as of now.
# Task = import('./3_classic_classes')._Task
Task = import('examples/3_classic_classes_module')._Task
Test = import('examples/5_default_import/using_export')

# Assigning to a local variable will make the variable available only within the top-level context.
# FIXME: 06/06/2018 relative paths don't work as of now.
# sys = import('./1_basic')
sys = import('examples/1_basic')

def exports.method_using_imported_library_as_a_constant
  Task.new("Repair the bike")
end

def exports.method_using_imported_library_as_a_variable
  sys.language
end

export test_proc: Proc.new { self }

# Here we are in Export instance, NOT in Context!
def exports.method_using_kernel_methods
  self
end
