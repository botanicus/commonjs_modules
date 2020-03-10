require 'import'

path = ARGV.shift
abort "Usage: #{$PROGRAM_NAME} examples/1_basic.rb" unless path && File.exist?(path)

exports = import(path)
binding.irb
