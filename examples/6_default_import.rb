#!/usr/bin/env ruby -Ilib -rimport

if __FILE__ == $0
  def exports
    @exports ||= Imports::Export.new(__FILE__)
  end

  include Imports::DSL
end

# Method 1: using the exports object
# exports.default = Test

# Method 2: using the export method
# class Test
# end

# export default: Test

# Method 3: using the export method in conjunction with a class definition
export default: class Test
  def test
  end

  self # Without this, it won't return the right thing.
end

# Method 3: using the export method in conjunction with an annonymous class definition
# NOTE that do/end block cannot be used.
# export default: Class.new {
#   # TODO: 06/06/2018 With this, exports.default shows the right thing,
#   # but exports.default.new still shows just an instance of an anonymous class.
#   def self.inspect
#     'Test'
#   end

#   def test
#   end
# }

(require 'pry'; binding.pry) if __FILE__ == $0
