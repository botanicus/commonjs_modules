#!/usr/bin/env ruby -Ilib -rimport
#
#exports.language = 'Ruby'
exports.VERSION_ = '0.0.1'

def exports.say_hello
  return "Hello World!"
end

(require 'pry'; binding.pry) if __FILE__ == $0