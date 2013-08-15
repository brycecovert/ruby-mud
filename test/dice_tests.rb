require 'ruby_mud'
require 'activesupport'
require 'test/unit'
require 'mocha'

class DiceTests < Test::Unit::TestCase

  def test_should_interpret_dice_string
    assert_equal 3, "3d5".to_dice.count
    assert_equal 5, "3d5".to_dice.sides
    assert_equal 0, "3d5".to_dice.constant

    assert_equal 5, "5d5+100".to_dice.count
    assert_equal 2, "5d2+100".to_dice.sides
    assert_equal 100, "5d5+100".to_dice.constant
  end
  
  def test_should_roll_all_5_dice
    dice = "5d5".to_dice
    5.times {dice.expects(:roll_one).returns(3)}
    assert_equal 15, dice.roll
    5.times {dice.expects(:roll_one).returns(2)}
    assert_equal 10, dice.roll
  end

  def test_should_roll_all_3_dice
    dice = "3d5".to_dice
    3.times {dice.expects(:roll_one).returns(3)}
    assert_equal 9, dice.roll
    3.times {dice.expects(:roll_one).returns(2)}
    assert_equal 6, dice.roll
  end

  def test_should_add_constant
    dice = "4d5+1000".to_dice
    dice.stubs(:roll_one).returns(0)
    assert_equal 1000, dice.roll
  end

end
