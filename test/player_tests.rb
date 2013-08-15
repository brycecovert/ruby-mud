require 'ruby_mud'
require 'test/unit'
require 'mocha'

class PlayerTest < Test::Unit::TestCase
  
  def setup
    World.instance.load
  end

  def fake_player
    player = Player.new(:name => "Bryce", :level => 10, :xp => 0, :per_level => 2500)
    player.save
    room = Room.new
    World.instance.rooms[room.id] = room
    World.instance.players.push player
    player.room = room
    player.room.characters.push player
    return player
  end

  def test_should_cease_fighting_upon_death
    victim = fake_player
    attacker = fake_player
    attacker.fighting = victim
    victim.die
    assert_nil attacker.fighting
  end

  def test_should_create_corpse_upon_death
    player = fake_player
    room = player.room
    assert !room.items.any? { |i| i.name =~ /corpse/ }
    player.die
    assert room.items.any? { |i| i.name =~ /corpse/ }
  end

  def test_should_die_if_injured_below_0_hp
    player = fake_player
    player.hp = 100
    player.expects(:die)
    player.injure 101
  end

  def test_should_display_room_description
    player = fake_player
    player.name = "Bryce"
    player.race = "elf"
    player.character_class = "warrior"
  
    assert_equal "Bryce the elf warrior is here.", player.room_description
  end

  def test_should_get_hit_damage_range_from_weapon
    player = fake_player
    player.worn('wielded') << Item.new(:attack_dice => "1d5+10")
    assert_equal "1d5+10", player.dam_dice.to_s
  end

  def test_should_use_level_for_damage_range_if_disarmed
    player = fake_player
    player.worn('wielded').delete_all
    player.level = 10
    assert_equal "10d2", player.dam_dice.to_s
  end

  def test_should_match_name
    player = fake_player
    player.name = "Bryce"
    assert player.matches? "Bryce"
    assert player.matches? "b"
  end

  def test_should_assign_race
    player = Player.new do |p|
      p.assign_race "human"
    end
    assert_equal 13, player.str
    assert_equal 13, player.int
    assert_equal 13, player.wis
    assert_equal 13, player.dex
    assert_equal 13, player.con
    assert_equal 200, player.max_hp
    assert_equal 200, player.hp
  end

  def test_should_move_character_to_recall_upon_death
    recall_room = Room.new
    World.instance.rooms[0] = recall_room
    player = fake_player
    room = player.room
    assert room.characters.include? player
    player.die
    assert !room.characters.include?(player)
    assert recall_room.characters.include?(player)
  end

  def test_should_heal_character_upon_death
    player = fake_player
    player.max_hp = 100
    player.hp = 20
    player.die
    assert_equal player.max_hp, player.hp
  end

  def test_should_grand_xp_upon_death_of_target
    player = fake_player
    player.xp = 0
    player.fighting = Mobile.new(:level => 1) { |m| m.save }
    player.fighting.die
    assert player.xp > 0 
  end

  def test_should_give_15_xp_per_level_over_ten
    player = fake_player
    player.level = 11
    assert_equal 0, player.calc_xp(Mobile.new(:level => 1))
    assert_equal 15, player.calc_xp(Mobile.new(:level => 2))
    assert_equal 30, player.calc_xp(Mobile.new(:level => 3))
    assert_equal 45, player.calc_xp(Mobile.new(:level => 4))
    assert_equal 60, player.calc_xp(Mobile.new(:level => 5))
  end

  def test_should_get_hit_word_from_equipment
    player = fake_player
    player.worn('wielded') << Item.new(:attack_word => "demolishing")
    assert_equal "demolishing", player.hit_word
  end

  def test_should_use_punch_if_naked
    player = fake_player
    assert_equal "punch", player.hit_word
  end

  def test_should_use_equipment_to_determine_ac
    player = fake_player
    assert_equal 0, player.ac_pierce
    assert_equal 0, player.ac_bash
    assert_equal 0, player.ac_slash
    assert_equal 0, player.ac_exotic
    player.worn('worn on head') << Item.new(:ac_pierce => -10, :ac_bash => -20, :ac_slash => -30, :ac_exotic => -40)
    assert_equal -10, player.ac_pierce
    assert_equal -20, player.ac_bash
    assert_equal -30, player.ac_slash
    assert_equal -40, player.ac_exotic
  end

  def test_corpse_should_contain_all_equipment
    player = fake_player
    player.inventory << Item.new(:name => "test item")
    assert player.create_corpse.contents.any? {|item| item.name == "test item" } 
  end

  def test_death_should_make_player_naked
    player = fake_player
    player.inventory << Item.new(:name => "test item")
    player.die
    assert player.inventory.none? {|item| item.name == "test item" } 
  end

  def test_equipment_slots_should_have_maximum_items
    player = fake_player
    player.worn('wielded') << Item.new(:name => "original item")
    player.worn('wielded') << Item.new(:name => "new item")
    assert_equal 'new item', player.worn('wielded').first.name
  end

end
