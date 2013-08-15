module Gossip
  def gossip args
    puts "You gossip '#{args.join(" ")}'."
    World.instance.characters.find_all {|char| char.notify "#{name} gossips '#{args.join(" ")}'." if char != self}
  end
end

