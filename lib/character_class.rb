
class CharacterClass
  attr_accessor :to_hit_ac
  attr_accessor :name
  MAX_LEVEL = 51
  
  def to_hit_ac_at_level level
    interpolate to_hit_ac.begin, to_hit_ac.end, level
  end
  
  def interpolate begin_value, end_value, value
    return (begin_value + value * (end_value-begin_value).to_f / MAX_LEVEL).to_i
  end
end

