require 'ruby_mud'
require 'test/unit'
require 'schema/load_rooms'

class LoadRoomsTest < Test::Unit::TestCase
  def setup
    World.instance.load
  end
  def test_should_load_mobs
    assert_equal 65, Mobile.find(:all).count
  end

  def test_should_load_hassan
    hassan = Mobile.find_by_name("Hassan")
    assert_equal "The Temple Of Mota", hassan.room.title.to_s
    assert_equal "1d1+3999", hassan.hp_dice
    assert_equal "hassan", hassan.keywords
    assert_equal "Hassan", hassan.name
    assert_equal "crush", hassan.attack_word
    assert_equal "5d4+40", hassan.attack_dice!.to_s
    assert_equal 45, hassan.level
  end

  def test_should_load_cityguard
    hassan = Mobile.find_by_name("the cityguard")
    assert_equal "cityguard guard", hassan.keywords
    assert_equal "the cityguard", hassan.name
  end

  def test_should_load_hassans_scimitar
    scimitar = Item.find_by_name("Hassan's scimitar")
    assert_equal "4d10", scimitar.attack_dice.to_s
    assert_equal "cleave", scimitar.attack_word
    assert_equal "weapon", scimitar.item_type
    assert_equal 'wielded', scimitar.slot
  end

  def test_should_load_pit
    pit = Item.find_by_name("the donation pit")
    assert_equal "container", pit.item_type
    assert_equal false, pit.takeable
    assert Room.find_by_title("By the temple altar").items.any? { |item| item.name == "the donation pit" }
  end

  def test_should_mark_objects_as_takeable
    assert Item.find_by_name("Hassan's scimitar").takeable
    assert !Item.find_by_name("the donation pit").takeable
  end

  def test_should_load_armor_acs
    assert_equal -3, Item.find_by_name("a standard issue cape").ac_pierce
    assert_equal -4, Item.find_by_name("a standard issue cape").ac_bash
    assert_equal -3, Item.find_by_name("a standard issue cape").ac_slash
    assert_equal -1, Item.find_by_name("a standard issue cape").ac_exotic
  end
end

