module Wearable
  def wear character
    character.puts "You wear #{name}."
    slot_contents = character.worn(slot)
    if slot_contents.count >= character.eq_slots.find { |s| s.name == slot }.max
      slot_contents[0] = self
    else
      slot_contents <<  self
    end
  end
end
