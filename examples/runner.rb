#!/usr/bin/env ruby -Ilib
# frozen_string_literal: true

require 'import'
require 'pry'

path = ARGV.shift
abort "Usage: #{$PROGRAM_NAME} examples/1_basic.rb" unless path && File.exist?(path)

exports = import(path)
binding.pry
