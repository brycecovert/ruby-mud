module Drop
  def drop args
    if args.empty?
      puts "What do you want to drop?"
      return
    end
    item = inventory.all.find { |i| i.matches? args.join(" ") }
    if item.nil?
      puts "You don't have a #{args.join ' '}."
      return
    end
    puts "You drop #{item.name}."
    room.items << item
    inventory.delete item
  end
end

