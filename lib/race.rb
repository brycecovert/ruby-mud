class Race
  World.instance.stats.each do |stat|
    attr_accessor "start_#{stat}".to_sym
    attr_accessor "max_#{stat}".to_sym
  end
end

