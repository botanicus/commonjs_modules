# frozen_string_literal: true

# Run with ./examples/runner.rb examples/file.rb

export Test: class Test
  def test
  end

  self # Without this, it won't return the right thing.
end
