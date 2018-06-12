# frozen_string_literal: true

# Run with ./examples/runner.rb examples/file.rb

# NOTE that do/end block cannot be used.
export default: Class.new {
  # TODO: 06/06/2018 With this, exports.default shows the right thing,
  # but exports.default.new still shows just an instance of an anonymous class.
  def self.inspect
    'Test'
  end

  def test
  end
}
