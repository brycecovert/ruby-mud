require 'ruby_mud'
require 'test/unit'

class CharacterClassTests < Test::Unit::TestCase

  def test_should_interpolate_to_hit_ac_based_on_level
    test_class = CharacterClass.new
    test_class.to_hit_ac = 0..51
    assert_equal 1, test_class.to_hit_ac_at_level(1)
    assert_equal 51, test_class.to_hit_ac_at_level(51)
    assert_equal 30, test_class.to_hit_ac_at_level(30)
  end

  def test_should_interpolate_to_hit_ac_based_on_level_2
    test_class = CharacterClass.new
    test_class.to_hit_ac = 0..102
    assert_equal 2, test_class.to_hit_ac_at_level(1)
    assert_equal 102, test_class.to_hit_ac_at_level(51)
    assert_equal 60, test_class.to_hit_ac_at_level(30)
  end
end
