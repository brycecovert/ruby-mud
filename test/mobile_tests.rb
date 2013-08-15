require 'ruby_mud'
require 'test/unit'

class MobileTest < Test::Unit::TestCase
  
  def setup
    World.instance.load
  end

  def fake_mobile
    mobile = Mobile.new
    mobile.save
    room = Room.new
    World.instance.rooms[room.id] = room
    World.instance.mobiles.push mobile
    mobile.room = room
    mobile.room.characters.push mobile
    return mobile
  end

  def test_should_use_short_description_for_room_description
    mobile = fake_mobile
    mobile.short_description = "Hassan is here, dispensing justice."
    assert_equal mobile.short_description, mobile.room_description
  end

  def test_should_have_equipment
    mobile = fake_mobile
    assert !mobile.eq_slots.empty?
  end

  def test_should_remove_character_from_room_upon_death
    mobile = fake_mobile
    room = mobile.room
    assert room.characters.include? mobile
    mobile.die
    assert !World.instance.rooms.values.any? { |r| r.characters.include? mobile }
    assert !World.instance.mobiles.include?(mobile)
  end

  def test_should_roll_dice_for_hp_and_mana
    mobile = Mobile.new(:hp_dice => "3d5", :mana_dice => "1d5")
    assert (3..15).include?(mobile.hp)
    assert (1..5).include?(mobile.mana)
  end

  def test_should_split_keywords
    mob = Mobile.new(:keywords => "cityguard guard")
    assert_equal ["cityguard", "guard"], mob.keywords!
  end

  def test_should_match_keywords
    mob = Mobile.new(:keywords => "cityguard guard")
    assert mob.matches? "cityguard"
    assert mob.matches? "c"
  end

  def test_should_get_hit_word_from_equipment
    mob = fake_mobile
    mob.worn('wielded') << Item.new(:attack_word => "demolishing")
    assert_equal "demolishing", mob.hit_word
  end

  def test_should_use_mobile_attack_word_if_naked
    mob = fake_mobile
    mob.attack_word = "hit"
    assert_equal "hit", mob.hit_word
  end

end
