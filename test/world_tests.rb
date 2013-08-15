require 'ruby_mud'
require 'test/unit'

class WorldTests < Test::Unit::TestCase
  
  def setup
    World.instance.load
  end

  def test_should_load_races
    assert World.instance.races.has_key? "elf"
    assert World.instance.races.has_key? "dwarf"
    assert World.instance.races.has_key? "human"
    assert World.instance.races.has_key? "giant"
  end

  def test_should_load_classes
    assert World.instance.classes.has_key? "warrior"
    assert World.instance.classes.has_key? "mage"
    assert World.instance.classes.has_key? "cleric"
    assert World.instance.classes.has_key? "thief"
  end

  def test_con_should_affect_hp_gains
    assert_equal -4, World.instance.hp_gain_for_con(0)
    assert_equal 8, World.instance.hp_gain_for_con(25)
  end
end
