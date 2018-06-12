#!/usr/bin/env ruby -Ilib
# frozen_string_literal: true

require 'import'
require 'pry'

path = ARGV.shift
unless path && File.exist?(path)
  abort "Usage: #{$0} examples/1_basic.rb"
end

exports = import(path)
binding.pry
