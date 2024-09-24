module PF2d::Drawable(T)
  # To be implemented by the including class
  abstract def draw_point(x, y, value : T)

  def draw_point(point : PF2d::Vec, value : T)
    draw_point(point.x, point.y, value)
  end
end

require "./drawable/draw_line"
require "./drawable/draw_circle"
