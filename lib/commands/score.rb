module Score
  def score args
    puts "You are #{short_description}."
    print  "Str: #{self.str}(#{current_str}) "
    print  "Int: #{self.int}(#{current_int}) "
    print  "Wis: #{self.wis}(#{current_wis}) "
    print  "Dex: #{self.dex}(#{current_dex}) "
    print  "Con: #{self.con}(#{current_con}) "
    puts
  end
end

