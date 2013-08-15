module Who
  def who args
    World.instance.describe_who_to(self)
  end
end

