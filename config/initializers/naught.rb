# https://github.com/avdi/naught

if defined? Naught
  NullObject = Naught.build
  BlackHole = Naught.build { |config| config.black_hole }
end
