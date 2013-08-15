 This file is part of RubyMud.
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
require 'connection'

def setup_database
  ActiveRecord::Schema.define do
    drop_table :rooms if table_exists? :rooms
    create_table :rooms do |t|
      t.column :title, :string
      t.column :description, :text
      t.column :to_south, :integer
      t.column :to_north, :integer
      t.column :to_east, :integer
      t.column :to_west, :integer
      t.column :to_up, :integer
      t.column :to_down, :integer
      t.column :slot_id, :integer
    end
    
    drop_table :mobiles if table_exists? :mobiles
    create_table :mobiles do |t|
      t.column :name, :string
      t.column :short_description, :string
      t.column :description, :text
      t.column :keywords, :string
      t.column :room_id, :integer
      t.column :level, :integer
      t.column :hp_dice, :string
      t.column :mana_dice, :string
      t.column :attack_dice, :string
      t.column :attack_word, :string
      t.column :str, :integer
      t.column :int, :integer
      t.column :wis, :integer
      t.column :dex, :integer
      t.column :con, :integer
      t.column :movement, :integer
    end

    drop_table :players if table_exists? :players
    create_table :players do |t|
      t.column :name, :string
      t.column :character_class, :string
      t.column :race, :string
      t.column :level, :integer
      t.column :hp, :integer
      t.column :max_hp, :integer
      t.column :mana, :integer
      t.column :max_mana, :integer
      t.column :str, :integer
      t.column :int, :integer
      t.column :wis, :integer
      t.column :dex, :integer
      t.column :con, :integer
      t.column :xp, :integer
      t.column :per_level, :integer
    end
    
    drop_table :items if table_exists? :items
    create_table :items do |t|
      t.column :name, :string
      t.column :keywords, :string
      t.column :short_description, :string
      t.column :aff_str, :integer, :default => 0
      t.column :aff_int, :integer, :default => 0
      t.column :aff_wis, :integer, :default => 0
      t.column :aff_dex, :integer, :default => 0
      t.column :aff_con, :integer, :default => 0
      t.column :ac_pierce, :integer, :default => 0
      t.column :ac_bash, :integer, :default => 0
      t.column :ac_slash, :integer, :default => 0
      t.column :ac_exotic, :integer, :default => 0
      t.column :attack_dice, :string, :default => "1d1+9"
      t.column :attack_word, :string
      t.column :takeable, :boolean, :default => false
      t.column :item_type, :string
      t.column :slot, :string
      t.column :contents_slot_id, :integer
    end

    drop_table :slots if table_exists? :slots
    create_table :slots do |t|
      t.column :name, :string
      t.column :max, :integer
    end

    drop_table :players_slots if table_exists? :players_slots
    create_table :players_slots, :id => false do |t|
      t.column :player_id, :integer
      t.column :slot_id, :integer
    end

    drop_table :mobiles_slots if table_exists? :mobiles_slots
    create_table :mobiles_slots, :id => false do |t|
      t.column :mobile_id, :integer
      t.column :slot_id, :integer
    end

    drop_table :slots_contents if table_exists? :slots_contents
    create_table :slots_contents, :id => false do |t|
      t.column :slot_id, :integer
      t.column :item_id, :integer
    end
  end
end
