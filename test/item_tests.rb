require 'ruby_mud'
require 'test/unit'

class ItemTests < Test::Unit::TestCase
  
  def setup
    World.instance.load
  end

  def test_should_load_dice
    item =Item.new(:attack_dice => "3d5")
    assert_equal(3, item.attack_dice!.count)
  end
end
