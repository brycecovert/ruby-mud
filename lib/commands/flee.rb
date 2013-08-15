module Flee
  def flee args
    if fighting.nil?
      puts "You aren't fighting anyone!"
      return
    end
    if (rand(3) == 1)
      puts "You escape in the nick of time."
      dir = room.exits.rand
      room_to_go_to = room.send "get_#{dir}"
      World.instance.characters.find_all { |char| char.fighting == self || char == self }.each { |char| char.fighting = nil }
      move_to room_to_go_to, :leave_description => "flees #{dir}!"
    else
      puts "PANIC! You can't escape!!"
    end
  end
end

