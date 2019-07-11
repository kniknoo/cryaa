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
  aa = Cryaa::AsciiArt.new(StumpyPNG.read(ARGV.first))
  puts aa.color_show(Colorize::Color256.new(rand(255).to_u8))
end

puts "#{reps} repetitions in #{Time.monotonic - start}"
puts "Made for #{ENV["USER"].upcase}"
