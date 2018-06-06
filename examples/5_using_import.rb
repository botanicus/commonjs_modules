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

# Assigning to a constant will make the variable available within classes.
# FIXME: 06/06/2018 relative paths don't work as of now.
# Task = import('./3_classic_classes')._Task
Task = import('examples/3_classic_classes_explicit')._Task
Test = import('examples/6_default_import')

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

def exports.method_using_kernel_methods
  # Here we are in Export instance, NOT in Context!
  puts "Hello world!"
end

(require 'pry'; binding.pry) if __FILE__ == $0
