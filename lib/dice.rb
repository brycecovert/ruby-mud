class Dice
  attr_accessor :count, :sides, :constant
  def initialize (params = {})
    params.each {|key, value| instance_variable_set("@" + key.to_s, value || 0) }
  end

  def roll
    value = constant
    count.times { value+= roll_one }
    value
  end

  def roll_one
    return rand(sides) + 1
  end

  def to_s
    return "#{count}d#{sides}#{"+" + constant.to_s if constant != 0}"
  end
end

class String
  def to_dice
    match = /(\d+)d(\d+)(\+\d*)*/.match(self)
    return Dice.new(:count => match[1].to_i, :sides => match[2].to_i, :constant => match[3].to_i)
  end
end
