module Go_down
  def go_down args
    attempt_move_to(room.get_down, :leave_description => "climbs down.")
  end
end

