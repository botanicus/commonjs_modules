# Run with ./examples/runner.rb examples/file.rb

export default: class Test
  def test
  end

  self # Without this, it won't return the right thing.
end

