module Helpers
  def generate_grid(boxes_x, boxes_y)
    #create a 2d array from 2 arrays
    boxes_y.flat_map { |y| boxes_x.map {|x| {x, y}}}
  end
  
  def quantize(dimension, b_dimension)
    #take in an x or y dimension and quantize it to block dimension
    (0..dimension).select{|x| x % b_dimension == 0 && x + b_dimension < dimension}
  end
  
  def to_grey(r, g, b)
    # returns the average of an rgb value
    (r.to_u16 + g.to_u16 + b.to_u16) / 3
  end
end
