require 'active_record'

class Mobile < ActiveRecord::Base
  include Character
  attr_accessor :hp, :max_hp, :mana, :max_mana
  has_and_belongs_to_many :slots, :class_name=>'Slot', :join_table=>'mobiles_slots'

  def hp_dice!
    return hp_dice.nil? ? nil : hp_dice.to_dice
  end

  def mana_dice!
    return mana_dice.nil? ? nil : mana_dice.to_dice
  end

  def after_initialize
    initialize_character
    self.room = World.instance.rooms[room_id]
    room.characters.push self unless World.instance.rooms.nil? or room.nil?
    World.instance.mobiles.push self unless World.instance.mobiles.nil?
    self.hp = self.max_hp = hp_dice!.roll unless hp_dice!.nil?
    self.mana = self.max_mana = mana_dice!.roll unless mana_dice!.nil?
  end
  
  def to_hit_ac
    return 16
  end

  def keywords!
    return keywords.split " "
  end

  def room_description
    short_description
  end
  
  def puts (*args)
  end

  def print (*args)
  end
  
  def notify (*args)
  end

  def attack_dice!
    attack_dice.nil? ? nil : attack_dice.to_dice
  end

  def naked_attack_word
    attack_word
  end
  
  def matches? input
    keyword = keywords!.find {|k| k.downcase.start_with? input.downcase }
    return keyword.nil? ? false : true
  end

  def die
    super
    room.characters.delete self
    World.instance.mobiles.delete self
  end

  def naked_dam_dice
    attack_dice!
  end
end
