module PF2d::Drawable(T)
  # Fill a circle using Bresenham’s Algorithm
  def fill_circle(cx : Int, cy : Int, r : Int, color)
    x, y = 0, r
    balance = 0 - r

    while x <= y
      p0 = cx - x
      p1 = cx - y

      w0 = x + x
      w1 = y + y

      scan_line(p0, cy + y, w0, color)
      scan_line(p0, cy - y, w0, color)
      scan_line(p1, cy + x, w1, color)
      scan_line(p1, cy - x, w1, color)

      x += 1
      balance += x + x

      if balance >= 0
        y -= 1
        balance -= (y + y)
      end
    end
  end

  def fill_circle(c : PF2d::Vec, r : Int, color)
    fill_circle(c.x, c.y, r, color)
  end
end
