
require "stumpy_png"
include StumpyPNG

GS_CHARS = "###@@@@%%%%&&&&****!!!!^^^^----''',,,..    ".reverse


def asciify(canvas : StumpyCore::Canvas, pix_w, pix_h)
  line = [] of String
  canvas.height.times do |y|
    y2 = y + pix_h
    return if y2 > canvas.height
    canvas.width.times do |x|
      x2 = x + pix_w
      if box_start?(x, y, pix_w, pix_h )
        if x2 > canvas.width
          puts line.join
          line = [] of String
          next
        else
          line << character_index(grey_of_box(canvas, x, y, pix_w, pix_h)).to_s          
        end
      end
    end
  end
end

def character_index(grey)
  #take in a grey value and give back a char
  char_index = ((grey.to_f / 255.0) * GS_CHARS.size.to_f).to_u8 
  char_index = GS_CHARS.size - 1 if char_index >= GS_CHARS.size
  GS_CHARS[char_index]
end

def to_grey(r, g, b)
  #returns the average of an rgb value
  (r.to_u16 + g.to_u16 + b.to_u16) / 3
end


def grey_of_box(canvas : StumpyCore::Canvas, x, y, box_w, box_h)
  #take in a canvas, x, y, , y2 and return a value of grey
  sum = 0
  box_h.times do |box_y| 
    box_w.times do |box_x| 
       sum += to_grey(*canvas[x + box_x, y + box_y].to_rgb8)
    end 
  end 
  return sum / (box_w * box_h)
end


def box_start?(x, y, pix_w, pix_h )
  #Time to start a new box?
  x % pix_w == 0 && y % pix_h == 0
end


start = Time.monotonic
canvas = StumpyPNG.read("tux.png")
asciify(canvas,4, 8)
puts "#{start - Time.monotonic}"
