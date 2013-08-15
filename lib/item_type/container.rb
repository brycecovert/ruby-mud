module ContainerItemType
  def contents
    contents_slot.contents
  end
  def describe_to character
    super character
    character.puts "The #{name} contains:"
    contents.each { |i| character.puts i.name }
  end

  def item_type_initialize
    self.contents_slot = Slot.new if contents_slot.nil?
  end
end
