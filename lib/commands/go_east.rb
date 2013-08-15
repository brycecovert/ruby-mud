module Go_east
  def go_east args
    attempt_move_to(room.get_east, :leave_description => "walks east.")
  end
end

