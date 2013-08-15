
class Intro
  attr_accessor :client
  def initialize (client)
    @client = client
  end
  def introduce
    client.print "By what name do you wish to be known? "
    name = client.gets.strip
    client.puts "Welcome, #{name}."
    character = Player.find_or_initialize_by_name(name)
    if character.new_record?
      puts "Creating new character #{character.name}"
      character.assign_race get_race client
      character_class = get_class client
      character.name = name
      character.character_class = character_class
      character.level = 1
      character.per_level = 1000
      character.xp = 0
      character.save
      character.slots << Slot.new(:name => 'inventory')
    end
    character.socket_client = client
    World.instance.players.push character
    character.move_to(World.instance.rooms[World.instance.rooms.keys.sort.first])
    character.puts
    character.prompt
    return character
  end

  def get_class (client)
      character_class = ask client,  "What class are you? [#{World.instance.classes.keys.sort.join(" ")}] "
      return character_class if World.instance.classes.has_key? character_class

      client.puts "That is not a valid class."
      return get_class client
  end

  def get_race (client)
      race = ask client,  "What race are you? [#{World.instance.races.keys.sort.join(" ")}] "
      if World.instance.races.has_key? race
        return race
      else
        client.puts "That is not a valid race."
        return get_race(client)
      end
  end
  def ask(client, message)
    client.print message
    return client.gets.strip
  end

end
