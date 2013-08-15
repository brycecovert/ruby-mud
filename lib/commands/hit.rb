module Hit
  def hit args
    if args.nil? or args.empty?
      puts "Hit whom?"
      return
    end
    victim = (@room.characters - [self]).find { |other| other.matches? args.join(" ") }
    if victim.nil?
      puts "You don't see them here."
    else
      if @fighting == victim
        puts "You're trying the best you can!"
        return
      end
      @fighting = victim
      BattleManager.instance.battle_round self
    end
  end
end

