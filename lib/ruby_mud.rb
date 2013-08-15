require 'singleton'
require "socket"
require "activerecord"
require 'range_extensions'
require 'dice'
require 'slot'
require 'world'
require "character_class"
require "item"
require "character"
require "player"
require "command"
require "room"
require "mobile"
require "input_parser"
require 'active_record'
require 'connection'
require 'intro'
require 'battle_manager'
require 'tick_manager'
require 'array_extensions'
require 'fixnum_extensions'
current_dir = File.dirname(__FILE__)
Dir[File.expand_path("#{current_dir}/item_type/*.rb")].uniq.each { |file| require file }
require 'mobile_movement_manager'
require 'race'
require 'yaml'


