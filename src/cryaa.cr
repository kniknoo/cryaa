# TODO: Write documentation for `Cryaa`

require "stumpy_png"

module Cryaa
  VERSION = "0.1.0"

  struct AsciiArt
    include StumpyPNG

    getter image : Canvas
    property ascii : Array(String) , chars : String, box_w : UInt8, box_h : UInt8
    property width : Int32, height : Int32

    def initialize(image : Canvas)
      @image = image
      @width = image.width
      @height = image.height
      @chars = "###@@@@%%%%&&&&****!!!!^^^^----''',,,..    ".reverse
      @box_w = 3
      @box_h = 6
      @ascii = asciify.not_nil!
      return @ascii
    end

    def asciify
      line = [] of String
      @height.times do |y|
        y2 = y + @box_h
        return line if y2 > @image.height
        @width.times do |x|
          x2 = x + @box_w
          if box_start?(x, y)
            if x2 > @width
              line << "\n"
              next
            else
              line << character_index(grey_of_box(x, y)).to_s
            end
          end
        end
      end
    end

    def character_index(grey)
      # take in a grey value and give back a char
      char_index = ((grey.to_f / 255.0) * @chars.size.to_f).to_u8
      char_index = @chars.size - 1 if char_index >= @chars.size
      @chars[char_index]
    end

    def to_grey(r, g, b)
      # returns the average of an rgb value
      (r.to_u16 + g.to_u16 + b.to_u16) / 3
    end

    def grey_of_box(x, y)
      # take in a canvas, x, y, , y2 and return a value of grey
      sum = 0
      @box_h.times do |box_y|
        @box_w.times do |box_x|
          sum += to_grey(*@image[x + box_x, y + box_y].to_rgb8)
        end
      end
      return sum / (@box_w * @box_h)
    end

    def box_start?(x, y)
      # Time to start a new box?
      x % @box_w == 0 && y % @box_h == 0
    end
  end
end
