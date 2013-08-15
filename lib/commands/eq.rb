module Eq
  def eq args
    puts "You are wearing:"
    eq_slots.each do |slot|
      slot_name = "<#{slot.name.capitalize}>"
      if !slot.contents.empty?
        slot.contents.each { |item| puts "#{slot_name.ljust(23)} #{item.name}" } 
      else
        puts "#{slot_name.ljust(23)} Nothing"
      end
    end
  end
end

