# This file is part of RubyMud.
# 
# RubyMud is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# RubyMud is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with RubyMud.  If not, see <http://www.gnu.org/licenses/>.
# 
$LOAD_PATH << "."
$LOAD_PATH << "./lib"
require 'ruby_mud'
World.instance.load
mob = Mobile.find(:all)
parser = InputParser.new
server = TCPServer.open(2000)
Command.load

Thread.abort_on_exception = true
BattleManager.begin_monitoring
TickManager.begin_monitoring
MobileMovementManager.begin_monitoring
loop {
  Thread.start(server.accept) do |client| 
    character = Intro.new(client).introduce
    loop {
      input = client.gets
      parser.parse(input, character)
      character.prompt
    }
  end
}
