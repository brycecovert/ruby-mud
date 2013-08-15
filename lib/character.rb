# This file is part of RubyMud.
# 
# RubyMud is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# RubyMud is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with RubyMud.  If not, see <http://www.gnu.org/licenses/>.
# 
module Character
  attr_accessor :socket_client
  attr_accessor :room
  attr_accessor :fighting
  attr_accessor :position
  
  [:str, :int, :wis, :dex, :con].each do |stat|
    eval %Q{
      def current_#{stat}
        worn_#{stat}_affects = equipment.inject(0) { |sum, item| sum + item.aff_#{stat} }
        #{stat} + worn_#{stat}_affects
      end
    }
  end

  [:ac_pierce, :ac_bash, :ac_slash, :ac_exotic].each do |ac|
    eval %Q{
        def #{ac}
          equipment.inject(0) { |sum, item| sum + item.#{ac} }
        end
    }
  end

  def inventory
    slots.find_by_name('inventory').contents
  end

  def eq_slots
    slots.find(:all).reject { |slot| slot.name == 'inventory' }.sort_by{ |slot| slot.name }
  end

  def equipment
    eq_slots.collect { |slot| slot.contents }.flatten
  end

  def worn slot
    slots.find_by_name(slot).contents
  end
  
  def ac
    return 10
  end

  def dam_dice
    return naked_dam_dice if worn('wielded').empty?
    return worn('wielded').first.attack_dice!
  end

  def initialize_character
    self.position = "standing"
    if slots.empty?
      Slot.equipment_slots.each { |slot| slots << Slot.new(:name => slot, :max => 1) }
      slots << Slot.new(:name => 'inventory')
    end
  end
  
  def move_to (room, options={})
    options = {
      :leave_description => 'disappears.'
    }.merge(options)
    
    if room.nil?
      return
    end
    if !@room.nil?
      @room.characters.delete self
      @room.characters.each { |character| character.notify "#{name} #{options[:leave_description]}" }
    end
    room.characters.each { |character| character.notify "#{name} has arrived." }
    room.characters.push self
    @room = room
  end

  def tnl
    return per_level * (level) - xp
  end
  
  def injure hp
    self.hp -= hp
    die if !is_alive?
  end

  def create_corpse
    corpse = Item.new(:name => 'corpse', :short_description => "#{name}'s corpse lies here.", :takeable=>true, :keywords=> 'corpse', :item_type=>'container') 
    corpse.save
    inventory.each { |item| corpse.contents << item }
    inventory.delete_all
    corpse
  end
  
  def die
    puts "You are DEAD!!!"
    room.items << create_corpse
    self.fighting = nil
    World.instance.characters.find_all { |char| char.fighting == self }.each {|char| char.killed_target }
  end
  
  def heal hp
    self.hp = [self.hp + hp, max_hp].min
  end
  
  def killed_target
    puts "#{fighting.name} is DEAD!!!"
    self.fighting = nil
  end

  def status
    (case (self.hp.to_f / self.max_hp) * 100
      when 100; "#{name} is in excellent condition."
      when 90...100; "#{name} has a few scratches."
      when 75...90; "#{name} has some small wounds and bruises."
      when 50...75; "#{name} has quite a few wounds."
      when 30...50; "#{name} has some big nasty wounds and scratches."
      when 15...30; "#{name} looks pretty hurt."
      when 0...15; "#{name} is in awful condition."
      else "#{name} is bleeding to death."
    end).capitalize
  end

  def hit_word
    worn('wielded').empty? ? naked_attack_word : worn('wielded').first.attack_word
  end

  def is_alive?
    return self.hp > 0 
  end

  def can_move?
    return @fighting.nil?, "You're kind of busy."
  end

  def attempt_move_to (room, options={})
    can_move, reason = can_move?
    if !can_move
      puts reason
      return
    end
    move_to room, options
  end

  def calc_xp victim
    return 0 if victim.level < level - 10
    (victim.level - (level - 10)) * 15
  end

  def tick_hp
    base_heal = (5 + level)
    base_heal *= 2 if position == "sleeping"
    base_heal
  end

  def attempt_go_to_sleep
    if fighting
      puts "You can't sleep during combat!"
      return
    end
    self.position = "sleeping"
    puts "You go to sleep."
  end

  def stand
    if !sleeping?
      puts "But you are already standing!"
      return
    end
    self.position = 'standing'
    puts "You stand up."
  end
  def sleeping?
    position == "sleeping"
  end

  def describe_to character
    character.puts description
  end
end
