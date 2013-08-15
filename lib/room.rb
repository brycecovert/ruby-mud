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
require 'active_record'

class Room  < ActiveRecord::Base
  attr_accessor :characters
  belongs_to :slot
  @@directions = [:north, :east, :south, :west, :up, :down]
  @@directions.each do |dir|
    eval %Q{
      def get_#{dir}
        return World.instance.rooms[to_#{dir}]
      end
    }
  end

  def items
    slot.contents
  end

  after_initialize :setup_links
  def setup_links
    self.characters = Array.new
    self.slot = Slot.new(:name => "#{title}'s items") if slot.nil?
  end

  def describe_to (character)
    character.puts title 
    character.puts description 
    character.puts
    
    character.puts "[Exits: #{exits.join(" ")}]"
    (@characters - [character]).each {|char| character.puts char.room_description }
    items.each { |item| character.puts item.short_description }
  end

  def exits
    return { to_south  => "south", to_north => "north", to_east => "east", to_west => "west", to_up => "up", to_down  => "down"}.find_all { |kvp| !kvp[0].nil? }.map { |dir| dir[1] }.sort
  end

end
