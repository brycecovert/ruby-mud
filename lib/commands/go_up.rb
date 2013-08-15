module Go_up
  def go_up args
    attempt_move_to(room.get_up, :leave_description => "climbs up.")
  end
end

