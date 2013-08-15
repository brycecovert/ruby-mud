module Quit
  def quit args
    save
    puts "Alas, all good things must come to an end."
    @socket_client.close
    @socket_client = nil
    Thread.kill(Thread.current)
  end
end

