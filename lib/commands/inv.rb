module Inv
  def inv args
    puts "You are carrying:"
    inventory.each { |item| puts "  #{item.name}" }
  end
end

