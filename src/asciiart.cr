require "stumpy_png"
require "./cryaa"
require "colorize"

if ARGV.size == 0
  puts "type a file name"
  exit
end

puts "reps:"
reps = gets.not_nil!.to_i 
start = Time.monotonic

reps.times do

aa_array = [] of String | Colorize::Object(String)
system "clear"
aa = Cryaa::AsciiArt.new(StumpyPNG.read(ARGV.first))
aa.ascii.each {|x| aa_array << x.colorize(Colorize::Color256.new(rand(255).to_u8))}
puts aa_array.join

end

puts "#{reps} repetitions in #{Time.monotonic - start}"
