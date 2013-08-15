
require 'ruby_mud'

class Command
  @@commands = Array.new
  attr_accessor :regex, :command, :exec_while_sleeping
  def Command.commands
    @@commands
  end

  def validate character
    if character.sleeping? && !exec_while_sleeping
      character.puts "You had better wake up first."
      return false
    end
    return true
  end

  def Command.load
    command = YAML::load_file('lib/commands.yaml')
    command.each { | cmd | 
      @@commands.push cmd 
      require "lib/commands/#{cmd.command}.rb"
      Player.send :include, self.class.const_get(cmd.command.to_s.capitalize)
    }
  end
end
