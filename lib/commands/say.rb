module Say
  def say args
    if !@room.nil?
      @room.characters.reject {|char| char == self }.each { |char| char.notify "#{name} says '#{args.join(" ")}'." }
    end
  end
end

