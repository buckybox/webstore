# frozen_string_literal: true

# https://github.com/avdi/naught

if defined? Naught
  NullObject = Naught.build
  BlackHole = Naught.build(&:black_hole)
end
