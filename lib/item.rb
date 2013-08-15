require 'active_record'

class Item < ActiveRecord::Base
  belongs_to :contents_slot, :class_name => 'Slot', :foreign_key => 'contents_slot_id'

  def after_initialize
    return if item_type.nil?
    item_type_name = "#{item_type.capitalize}ItemType".to_sym
    extend self.class.const_get(item_type_name)
    item_type_initialize
  end

  def item_type_initialize
  end

  def describe_to character
    character.puts short_description
  end

  def attack_dice!
    return nil if attack_dice.nil?
    return attack_dice.to_dice
  end

  def keywords!
    keywords.split ' '
  end

  def matches? input
    keywords!.any? {|k| k.downcase.start_with? input.downcase }
  end

  def wear character
    character.puts "You can't wield or wear #{name}."
  end
end

