module PF2d::Drawable(T)
  # Fill a rect
  def fill_rect(x1 : Int, y1 : Int, x2 : Int, y2 : Int, color)
    # draw from top left to bottom right
    y1, y2 = y2, y1 if y1 > y2
    x1, x2 = x2, x1 if x1 > x2

    y1.upto(y2) do |y|
      x1.upto(x2) do |x|
        draw_point(x, y, color)
      end
    end
  end

  # ditto
  def fill_rect(p1 : PF2d::Vec, p2 : PF2d::Vec, color)
    fill_rect(p1.x, p1.y, p2.x, p2.y, color)
  end
end
