module PF2d
  VERSION = {% `shards version`.chomp.stringify %}

  def self.degrees_to_radians(degrees : Float)
    degrees * Math::PI / 180.0
  end
end

require "./pf2d/matrix"
require "./pf2d/vec"
require "./pf2d/transform"
require "./pf2d/threaded_binary_tree"
require "./pf2d/line"
require "./pf2d/rect"
require "./pf2d/circle"
require "./pf2d/ray"
require "./pf2d/bezier"
require "./pf2d/tri"
require "./pf2d/poly"
require "./pf2d/quad"
require "./pf2d/quad_spline"

require "./pf2d/drawable"
require "./pf2d/viewable"
require "./pf2d/canvas"
require "./pf2d/clip"
require "./pf2d/grid"
