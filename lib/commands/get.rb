module Get
  def get args
    if args.empty?
      puts "What do you want to retrieve?"
      return
    end
    if args.include? "from"
      get_from_container args
    else
      get_from_room args
    end
  end

  def get_from_container args
    item_name = (args.split "from")[0].join " "
    container_name = (args.split "from")[1].join " "
    container = room.items.all.find { |i| i.matches? container_name and i.item_type == "container" }
    if container.nil?
      puts "You don't see a #{container_name}"
      return
    end
    item = container.contents.all.find { |i| i.matches? item_name }
    if item.nil?
      puts "That item is not found."
      return
    end
    if !item.takeable
      puts "You can't pick up the #{item.name}."
      return
    end
    puts "You pick up #{item.name} from #{container.name}."
    container.contents.delete item
    inventory.push item
  end

  def get_from_room args
    item = room.items.all.find { |i| i.matches? args.join(" ") }
    if item.nil?
      puts "That item is not found."
      return
    end
    if !item.takeable
      puts "You can't pick up the #{item.name}."
      return
    end
    puts "You pick up #{item.name}."
    room.items.delete item
    inventory.push item
  end
end

