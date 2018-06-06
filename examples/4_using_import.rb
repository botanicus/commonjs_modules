#!/usr/bin/env ruby -Ilib -rimport
#
## Assigning to a constant will make the variable available within classes.
Task = import('./3_classic_classes')._Task

# Assigning to a local variable will make the variable available only within the top-level context.
sys  = import('./1_basic')

def main
  p Task.new("Repair the bike")
  puts sys.language
end

(require 'pry'; binding.pry) if __FILE__ == $0
