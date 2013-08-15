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

require 'ruby_mud'
require 'profiler'
World.instance.load
class Room
  attr_accessor :to_south_id, :to_north_id, :to_west_id, :to_east_id, :to_up_id, :to_down_id
  attr_accessor :vnum
end

class Mobile
  attr_accessor :vnum, :room_vnum
end

class Item
  attr_accessor :vnum, :room_vnum
end

@@slot_map = {  
  'B' => 'worn on finger',
  'C' => 'worn around neck',
  'D' => 'worn about body' ,
  'E' => 'worn on head',
  'F' => 'worn on legs',
  'G' => 'worn on feet' ,
  'H' => 'worn on hands' ,
  'I' => 'worn on arms' ,
  'J' => 'worn as shield' ,
  'K' => 'worn on torso',
  'L' => 'worn about waist',
  'M' => 'worn around wrist',
  'N' => 'wielded' ,
  'O' => 'held' ,
  'Q' => 'floating nearby' }

class Array
  def split_on_vnum
    split_where { |line| line =~ /#[0-9]/ }
  end

  def room_id_for_vnum vnum
    find { |room| room.vnum == vnum }
  end

  def section name, next_section
    slice(index(name)+1...index(next_section) -2)
  end
end

def get_room_vnum vnum, lines, type
  find_room_for_item = /^#{type} \d #{vnum}\W*\d\W*(\d{4})/
  room_line = lines.find { |line| line =~ find_room_for_item }
  return room_line.nil? ? nil : find_room_for_item.match(room_line)[1] 
end

def get_room_id(lines, direction)
  direction_regex = /D(#{direction})/
  room_regex = /\w+ [\w\-]+ (\w+)$/ 
  direction_definition_index = lines.find_index{ |line| line =~ direction_regex }
  if (direction_definition_index.nil?)
    return
  end
  direction_num = direction_regex.match(lines[direction_definition_index])[1]
  room_line = lines[ direction_definition_index...lines.length ].find { |x| x =~ room_regex }
  room_vnum = room_regex.match(room_line)[1]
end

def get_room_infos(lines)
  (lines.split_on_vnum.collect do |room_lines|
    Room.new do |room|
      room.vnum = /#([0-9]+)/.match(room_lines[0])[1]
      room.title = /[^~]*/.match(room_lines[1])[0]
      room.description = room_lines.slice(2...room_lines.length).take_while { |line| line !~ /\~/ }.join

      room.to_north_id = get_room_id(room_lines, 0)
      room.to_east_id = get_room_id(room_lines, 1)
      room.to_south_id = get_room_id(room_lines, 2)
      room.to_west_id = get_room_id(room_lines, 3)
      room.to_up_id = get_room_id(room_lines, 4)
      room.to_down_id = get_room_id(room_lines, 5)
    end
  end).to_a
end

def assign_directions room, rooms
  [:north, :east, :south, :west, :up, :down].each do |dir|
    eval %Q{
      #{dir}_room = rooms.find {|other| other.vnum == room.to_#{dir}_id }
      room.to_#{dir} = #{dir}_room.id unless #{dir}_room.nil?
    }
  end
end

def load_rooms lines
  room_lines = lines.section "#ROOMS\n", "#RESETS\n"
  Room.delete_all
  rooms = get_room_infos(room_lines)
  rooms.each { |room| room.save } 
  rooms.each { |room| assign_directions room, rooms }
  rooms.each { |room| room.save } 
  return rooms
end

def get_mobile_infos mobs_lines, reset_lines
  mobs_lines.split_on_vnum.collect do |mob_lines|
    Mobile.new do |mob|
      mob.keywords = /[^~]*/.match(mob_lines[1])[0].downcase
      mob.name = /[^~]*/.match(mob_lines[2])[0]
      mob.short_description = mob_lines[3]
      mob.vnum = /#([0-9]+)/.match(mob_lines[0])[1]
      mob.room_vnum = get_room_vnum mob.vnum, reset_lines, 'M'
      dice_line = mob_lines.find {|line| line =~ /\d+d\d+/ }.split ' '
      mob.level = dice_line[0]
      mob.hp_dice = dice_line[2]
      mob.mana_dice = dice_line[3]
      mob.attack_dice = dice_line[4]
      mob.attack_word = dice_line.last
      mob.movement = rand(100)
    end
  end
end

def load_mobiles lines, reset_lines, rooms
  mobile_lines = lines.section "#MOBILES\n", "#OBJECTS\n"
  Mobile.delete_all
  mobiles = get_mobile_infos mobile_lines, reset_lines
  mobiles.each { |mob| room = rooms.room_id_for_vnum(mob.room_vnum); mob.room_id = room.id unless room.nil?  }
  mobiles.each { |mob| mob.save } 
  return mobiles
end


def get_item_infos items_lines, reset_lines
  items_lines.split_on_vnum.collect do |item_lines|
    Item.new do |item|
      item.vnum = /#(\d+)/.match(item_lines.shift)[1]
      item.keywords = /[^~]+/.match(item_lines.shift)[0].downcase
      item.name = /[^~]+/.match(item_lines.shift)[0]
      item.short_description = /[^~]+/.match(item_lines.shift)[0]
      item.room_vnum = get_room_vnum item.vnum, reset_lines, 'O'
      item_lines.drop_while { |item_line| item_line !~ /~/ }
      item_lines.shift
      type_line = item_lines.shift.split(' ')
      flags = type_line.last
      item.takeable = flags.include?('A') 
      item.slot = @@slot_map[@@slot_map.keys.find { |k| flags.include? k }]
      item.item_type = type_line[0]
      if item.item_type == 'weapon'
        value_line = item_lines.shift.split ' '
        item.attack_dice = "#{value_line[1].to_s}d#{value_line[2]}"
        item.attack_word = value_line[-2]
      end
      if item.item_type == 'container'
        item.contents_slot = Slot.new
      end
      ac_line = item_lines.shift.split ' '
      item.ac_pierce = -ac_line[0].to_i
      item.ac_bash = -ac_line[1].to_i
      item.ac_slash = -ac_line[2].to_i
      item.ac_exotic = -ac_line[3].to_i
    end
   end
end

def load_items lines, reset_lines, rooms
  item_lines = lines.section "#OBJECTS\n", "#ROOMS\n"
  Item.delete_all
  items = get_item_infos item_lines, reset_lines
  items.each { |item| room = rooms.room_id_for_vnum(item.room_vnum);  room.items << item unless room.nil? }
  items.each { |i| i.save }
end

def load_area filename
  Slot.delete_all
  file = File.open filename
  lines = file.readlines
  reset_lines = lines.section "#RESETS\n", "#SHOPS\n"
  rooms = load_rooms lines
  mobiles = load_mobiles lines, reset_lines, rooms
  items = load_items lines, reset_lines, rooms
end
