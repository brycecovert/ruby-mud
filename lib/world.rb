class World
  include Singleton
  attr_accessor :rooms, :races, :mobiles, :players, :classes
  STAT_RANGE=(0..25)

  def stats
    [:str, :int, :wis, :dex, :con, :hp, :mana]
  end
  
  def load
    @rooms = Hash[*Room.find(:all).map { |r| [r.id,  r] }.flatten]
    @races = YAML::load(File.read("#{File.dirname(__FILE__)}/races.yaml"))
    @classes = YAML::load(File.read("#{File.dirname(__FILE__)}/classes.yaml"))
    @players = Array.new
    @mobiles = Array.new
    pit = Item.find_by_name("the donation pit")
    unless pit.nil? || !pit.contents.empty?
      Item.find(:all).each { |i|  pit.contents.push i }
      pit.save
    end
  end

  def characters
    [*@players + @mobiles]
  end

  def describe_who_to character
    players.each do |char| 
      character.puts "[#{char.level} #{char.race.first(3).capitalize} #{char.character_class.first(3).capitalize}] #{char.short_description}"
    end
    character.puts "#{players.length} players found."
  end

  def hp_gain_for_con con
    return STAT_RANGE.interpolate(-4, 8)[con]
  end
end
