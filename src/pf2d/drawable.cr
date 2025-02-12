module PF2d::Drawable(T)
  # To be implemented by the including class
  abstract def draw_point(x : Number, y : Number, value : T)

  def draw_point(point : PF2d::Vec, value : T)
    draw_point(point.x, point.y, value)
  end
end

require "./drawable/draw_circle"
require "./drawable/draw_curve"
require "./drawable/draw_line"
require "./drawable/draw_rect"
require "./drawable/draw_spline"
require "./drawable/fill_circle"
require "./drawable/fill_poly"
require "./drawable/fill_rect"
require "./drawable/fill_spline"
require "./drawable/fill_triangle"
require "./drawable/paint_triangle"
