module Go_south
  def go_south args
    attempt_move_to(room.get_south, :leave_description => "walks south.")
  end
end

