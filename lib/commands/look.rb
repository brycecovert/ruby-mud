
module Look
  def look (args)
    if args.empty?
      room.describe_to self
      return
    end
    match = [*room.characters + room.items].find {|candidate| candidate.matches? args.join(' ') }
    if !match.nil?
      match.describe_to self
    else
      puts "Nothing is there."
    end
  end
end
