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
class Array
  def find_index (&block)
    return index(find(&block))
  end

  def indices_that(&block)
    select(&block).map { |item| index(item) }
  end
  
  def split_where(&block)
    arrays = Array.new
    current_index = 0
    indexes = indices_that(&block) 
    for i in 0...indexes.length-1
      arrays.push slice(indexes[i]...indexes[i+1])
    end
    arrays.push slice(indexes.last...length)
    return arrays
  end
end

