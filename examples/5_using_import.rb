#!/usr/bin/env ruby -Ilib -rimport

# Assigning to a constant will make the variable available within classes.
# FIXME: 06/06/2018 relative paths don't work as of now.
# Task = import('./3_classic_classes')._Task
Task = import('examples/3_classic_classes')._Task
Test = import('examples/4_default_import')

# Assigning to a local variable will make the variable available only within the top-level context.
# FIXME: 06/06/2018 relative paths don't work as of now.
# sys  = import('./1_basic')
sys  = import('examples/1_basic')

def exports.method_using_imported_library_as_a_constant
  Task.new("Repair the bike")
end

def exports.method_using_imported_library_as_a_variable
  sys.language
end

def exports.method_using_kernel_methods
  puts "Hello world!"
end

(require 'pry'; binding.pry) if __FILE__ == $0
