require "stumpy_png"
require "./cryaa"


if ARGV.size == 0
puts "type a file name"
exit 
end

Cryaa::AsciiArt.new(StumpyPNG.read(ARGV.first))
