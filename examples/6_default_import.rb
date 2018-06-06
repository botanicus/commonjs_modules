#!/usr/bin/env ruby -Ilib -rimport

class Test
end

# Either is correct:
# exports.default = Test
export default: Test

(require 'pry'; binding.pry) if __FILE__ == $0
