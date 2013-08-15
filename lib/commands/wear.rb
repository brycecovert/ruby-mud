
module Wear
  def wear (args)
    if args.empty?
      puts "Wear what?"
      return
    end
    item = args.join " "
    inventory_item = inventory.all.find {|inventory_item| inventory_item.matches? item }
    if inventory_item.nil?
      puts "You don't have a #{item}."
      return
    end 
    inventory_item.wear self
    end
end
