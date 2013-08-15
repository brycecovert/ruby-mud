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
class InputParser
  def parse(input, character)
    input_cleaned = input.strip.split
    command = input_cleaned.first
    args = input_cleaned.slice(1...input_cleaned.length)
    candidate = Command.commands.find { |cmd| cmd.regex.match(command) }
    if !candidate.nil?
      character.send candidate.command, args if candidate.validate character
    else
      character.puts "Huh?"
    end
  end
end
