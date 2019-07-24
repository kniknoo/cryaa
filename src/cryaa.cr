# TODO: Write documentation for `Cryaa`

require "stumpy_png"
require "colorize"
require "./helpers"

module Cryaa
  VERSION = "0.1.0"

  struct AsciiArt
    include StumpyPNG
    include Helpers

    getter image : Canvas
    property ascii : Array(Char), chars : String, box_w : UInt8, box_h : UInt8
    property width : Int32, height : Int32
    property boxes_x : Array(Int32), boxes_y : Array(Int32)
    property grid : Array(Tuple(Int32, Int32)), colorchart : Array(StumpyCore::RGBA)

    def initialize(image : Canvas)
      @image = image
      @width = image.width
      @height = image.height
      @box_w = 3
      @box_h = 6
      @boxes_x = quantize(@width, @box_w)
      @boxes_y = quantize(@height, @box_h)
      @grid = generate_grid(@boxes_x, @boxes_y)
      @chars = "###@@@@%%%%&&&&****!!!!^^^^----''',,,..    ".reverse
      @colorchart = sample_image
      @ascii = asciify
    end
    
    def sample_image
      # scan the image using the grid as an origin point for each block
      grid.map {|x, y| average(color_of_box(x, y)) }
    end
    
    def color_of_box(x, y)
      #take in an x, y and return an array of the colors
      (y...y2(y)).flat_map do |box_y| 
        (x...x2(x)).map do |box_x| 
          @image[box_x, box_y] 
        end 
      end
    end
    
    def average(colors)
        color_avg = [0, 0, 0]
        # Take in an RGBA value and return the average
        colors.each do |color| 
          color_avg[0] += color.r
          color_avg[1] += color.g
          color_avg[2] += color.b
        end
        color_avg.each {|color| color = (color / colors.size)}
        RGBA.new(color_avg[0].to_u16, color_avg[1].to_u16, color_avg[2].to_u16)
    end
    
    def y2(y)
      y + @box_h
    end
    
    def x2(x)
      x + @box_w
    end
    
    def show
      system "clear"
      @ascii.each_slice(@boxes_x.size) { |row| puts row.join}
    end
    
    def color_show(color)
      system "clear"
      @ascii.each_slice(@boxes_x.size) { |row| puts row.join.colorize(color)}.to_rgb8
    end
    
    def asciify
      #take in an image and return a character representation
      grid.map { |x, y| character_index(grey_of_box(x, y))}
      #@colorchart.map do |color| 
      #  character_index(to_grey(color))
      #end
    end

    def character_index(grey)
      # take in a grey value and give back a char
      char_index = ((grey.to_f / 255.0) * @chars.size.to_f).to_u8
      char_index = @chars.size - 1 if char_index >= @chars.size
      @chars[char_index]
    end

    def grey_of_box(x, y)
      # take in an x,y and return a value of grey
      sum = 0
      @box_h.times do |box_y|
        @box_w.times do |box_x|
          sum += to_grey(@image[x + box_x, y + box_y].to_rgb8)
        end
      end
      sum / (@box_w * @box_h)
    end
    
  end  
end
