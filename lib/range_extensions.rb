class Range
  def interpolate min, max
    Hash[zip(map {|x| (min + (max-min)*(x.to_f/(count-1))).round} )]
  end
end
