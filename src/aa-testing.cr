
require "stumpy_png"
include StumpyPNG

GS_CHARS = "###@%&*!^-',.    "

def greyscale(canvas : StumpyCore::Canvas)
  #Returns a greyscaled canvas
  canvas.height.times do |y|
    canvas.width.times do |x|
      sum = to_grey(*canvas[x, y].to_rgb8)
      canvas[x, y] = RGBA.from_gray_n(sum, 8)
    end
  end 
  return canvas
end

def to_grey(r, g, b)
  #returns the average of an rgb value
  (r.to_u16 + g.to_u16 + b.to_u16) / 3
end

def pixelate(canvas : StumpyCore::Canvas, pix_w, pix_h)
  canvas.height.times do |y|
    canvas.width.times do |x|
      if pixel_start?(x, y, pix_w, pix_h ) 
        next if x + pix_w > canvas.width || y + pix_h > canvas.height
        canvas = fill_with_average(canvas, x, y, pix_w, pix_h, average_pixels(canvas, x, y, pix_w, pix_h) )
      end
    end
  end
 return canvas 
end

def asciify(canvas : StumpyCore::Canvas, pix_w, pix_h)
  canvas.height.times do |y|
    canvas.width.times do |x|
      if pixel_start?(x, y, pix_w, pix_h ) 
        if x + pix_w > canvas.width
          puts "#{x}, #{y}" 
          next 
        end
        return if y + pix_h > canvas.height
        char_index = average_pixels(canvas, x, y, pix_w, pix_h) / 16
        char_index = 0 if char_index < 0
        char_index = 15 if char_index > 15
        print GS_CHARS[char_index]
      end
    end
  end
end

def average_pixels(canvas : StumpyCore::Canvas, x, y, pix_w, pix_h)
  #return average greyscale value of the sub-array of an image
  sum = 0_i16
  (y...(y + pix_h)).each do|j| 
    (x...(x + pix_h)).each do|i|
      sum += to_grey(*canvas[i, j].to_rgb8)
    end
  end
  return sum / (pix_w * pix_h)
end

def fill_with_average(canvas : StumpyCore::Canvas, x, y, pix_w, pix_h, grey)
  (y...(y + pix_h)).each do|j| 
    (x...(x + pix_h)).each do|i|
      canvas[i, j] = RGBA.from_gray_n(grey, 8)
    end
  end
  return canvas
end

def fill_screen_with_text(canvas : StumpyCore::Canvas, x, y, pix_w, pix_h, grey)
  (y...(y + pix_h)).each do|j| 
    (x...(x + pix_h)).each do|i|
      canvas[i, j] = RGBA.from_gray_n(grey, 8)
    end
  end
  return canvas
end

def pixel_start?(x, y, pix_w, pix_h )
  x % pix_w == 0 && y % pix_h == 0
end

start = Time.monotonic
canvas = StumpyPNG.read("tux.png")
asciify(canvas,6, 8)
#canvas = greyscale(canvas)
#canvas = pixelate(canvas, 3, 4)
#StumpyPNG.write(canvas, "greypixeltux.png")
#StumpyPNG.write(canvas, "greytux.png")
puts "#{start - Time.monotonic}"
