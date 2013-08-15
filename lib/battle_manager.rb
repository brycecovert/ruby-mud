
class BattleManager
  include Singleton
  attr_accessor :lock
  
  def process
      characters_fighting = World.instance.characters.find_all { |character| !character.fighting.nil? }
      characters_fighting.each { |character| battle_round(character) }
      characters_fighting.each { |character| character.puts character.fighting.status if character.fighting }
      characters_fighting.each { |character| character.prompt if character.is_a? Player }
  end
  
  def battle_round attacker
    @lock.synchronize {
      if attacker.fighting.nil?
        return
      end
      victim = attacker.fighting
      attacker.puts "\n"
      victim.puts "\n"
      if victim.fighting.nil?
        victim.fighting = attacker
      end
      if !does_hit? attacker, victim
        attacker.puts "You miss."
        return
      end
      damage = attacker.dam_dice.roll
      attacker.puts "Your #{damage.to_damage_string[0]} #{attacker.hit_word} #{damage.to_damage_string[1]} #{victim.name}!"
      victim.puts "#{attacker.name}'s #{attacker.hit_word} #{damage.to_damage_string[1]} you!".capitalize
      victim.injure damage
    }
  end

  def does_hit? attacker, victim
    return rand(21)  >= attacker.to_hit_ac - victim.ac
  end

  def BattleManager.begin_monitoring
    BattleManager.instance.lock = Mutex.new
    Thread.start do
      loop {
        BattleManager.instance.process
        sleep 2
      }
    end
  end
end
