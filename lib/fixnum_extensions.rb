class Fixnum
  @@damage_strings = { 
    0..4 => ['wobbly', 'scratches'],
    5..8 => ['weak', 'grazes'],
    9..12 => ['pleasant', 'hits'],
    13..16 => ['skillful', 'injures'],
    17..20 => ['competent', 'wounds'],
    21..24 => ['cunning', 'mauls'],
    25..28 => ['calm', 'decimates'],
    29..32 => ['learned', 'devistates'],
    33..36 => ['talented', 'maims'],
    37..40 => ['calculated', 'MUTILATES'],
    41..44 => ['calculated', 'DISEMBOWELS'],
    45..48 => ['wicked', 'DISMEMBERS'],
    49..52 => ['wicked', 'MASSACRES'],
    53..56 => ['wicked', 'MANGLES'],
    57..60 => ['wicked', '*** DEMOLISHES ***'],
    61..75 => ['masterful', '*** DEVASTATES ***'],
    76..100 => ['masterful', '=== OBLITERATES ==='],
    101..125 => ['masterful', '>>> ANNIHILATES <<<'],
    126..150 => ['masterful', '<<< ERADICATES >>>'],
    151..9999 => ['masterful', 'does UNSPEAKABLE THINGS to'],
  }
  def to_damage_string
    @@damage_strings[@@damage_strings.keys.find { |k| k.include? self }] || ["does an unknown amount of damage #{self.to_s}", "does an unknown amount of damage #{self.to_s}"]
  end

  def spread
    ((self * 0.75).round..(self * 1.25).round).to_a.sample
  end
end

