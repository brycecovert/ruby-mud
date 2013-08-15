class TickManager
  include Singleton

  def process
    World.instance.characters.each { |char| tick_heal (char) } 
    World.instance.players.each { |player| player.save } 
  end

  def tick_heal char
    char.heal char.tick_hp.spread
    char.notify 
  end

  def TickManager.begin_monitoring
    Thread.start do
      loop {
        TickManager.instance.process
        sleep 30
      }
    end
  end
end

