module Go_west
  def go_west args
    attempt_move_to(room.get_west, :leave_description => "walks west.")
  end
end

