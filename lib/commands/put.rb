module Put
  def put args
    if args.empty?
      puts "What do you want to drop?"
      return
    end
    if !args.include? "into"
      puts "What do you want to put it into?"
    end
    item_name = (args.split "into")[0].join " "
    container_name = (args.split "into")[1].join " "
    item = inventory.all.find { |i| i.matches? item_name }
    if item.nil?
      puts "You don't have a #{item_name}."
      return
    end
    container = room.items.find { |i| i.matches? container_name and i.item_type == "container" }
    if container.nil?
      puts "I don't see a #{container_name}."
      return
    end
    puts "Ok."
    container.contents << item
    inventory.delete item
  end
end

