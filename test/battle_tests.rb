require 'ruby_mud'
require 'test/unit'

class BattleTests < Test::Unit::TestCase
  
  def setup
    World.instance.load
  end
  def test_pass
    assert true
  end
end
