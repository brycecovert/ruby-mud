module Go_north
  def go_north args
    attempt_move_to(room.get_north, :leave_description => "walks north.")
  end
end

