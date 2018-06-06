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

# Method 1
# export class Test
#   self # Required.
# end

# Method 2
# TODO: 06/06/2018 Define inspect based for this.
export Class.new {
  def self.name
    'Test'
  end
}

(require 'pry'; binding.pry) if __FILE__ == $0
