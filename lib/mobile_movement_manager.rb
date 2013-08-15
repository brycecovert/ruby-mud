class MobileMovementManager
  include Singleton

  def process
    World.instance.mobiles.each { |mob| move (mob) } 
  end

  def move mob
    return if mob.room.exits.none?
    if mob.movement > rand(100)
      room = nil
      while room.nil? do 
        direction = rand(4)
        directions = ['get_east', 'get_west', 'get_north', 'get_south'];
        room = mob.room.send directions[direction]
        mob.attempt_move_to room unless room.nil?
        puts "Moving #{mob.name} to #{room.title}." unless room.nil?
      end
    end
  end

  def MobileMovementManager.begin_monitoring
    Thread.start do
      loop {
# MobileMovementManager.instance.process
        sleep 20
      }
    end
  end
end

