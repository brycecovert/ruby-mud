require 'ruby_mud'
require 'test/unit'
require 'mocha'

class FixnumExtensionsTest < Test::Unit::TestCase
  def test_should_spread
    num = 8
    assert 6 <= num && num <= 10

  end
end
