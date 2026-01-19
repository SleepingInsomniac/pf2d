module PF2d::Drawable(T)
  # Draws the outline of a rect
  def draw_rect(x1 : Int, y1 : Int, x2 : Int, y2 : Int, value : T)
    # draw from top left to bottom right
    y1, y2 = y2, y1 if y1 > y2
    x1, x2 = x2, x1 if x1 > x2

    x1.upto(x2) do |x|
      draw_point(x, y1, value)
      draw_point(x, y2, value)
    end

    y1.upto(y2) do |y|
      draw_point(x1, y, value)
      draw_point(x2, y, value)
    end
  end

  def draw_rect(x1 : Float, y1 : Float, x2 : Float, y2 : Float, value : T)
    draw_rect(x1.to_i, y1.to_i, x2.to_i, y2.to_i, value)
  end

  # ditto
  def draw_rect(rect : PF2d::Rect, value : T)
    draw_rect(rect.top_left.to_i32, rect.bottom_right.to_i32, value)
  end

  def draw(rect : PF2d::Rect, value : T)
    draw_rect(rect, value)
  end

  # ditto
  def draw_rect(p1 : PF2d::Vec, p2 : PF2d::Vec, value : T)
    draw_rect(p1.x, p1.y, p2.x, p2.y, value)
  end

  # ditto
  def draw_rect(size : PF2d::Vec, value : T)
    draw_rect(0, 0, size.x, size.y, value)
  end
end
