module PF2d::Drawable(T)
  # Draw a circle using Bresenham’s Algorithm
  def draw_circle(cx : Number, cy : Number, r : Number, color)
    x, y = 0, r
    d = 3 - 2 * r # Decision

    loop do
      draw_point(cx + x, cy + y, color)
      draw_point(cx - x, cy + y, color)
      draw_point(cx + x, cy - y, color)
      draw_point(cx - x, cy - y, color)
      draw_point(cx + y, cy + x, color)
      draw_point(cx - y, cy + x, color)
      draw_point(cx + y, cy - x, color)
      draw_point(cx - y, cy - x, color)

      break if x > y

      x += 1

      if d > 0
        y -= 1
        d = d + 4 * (x - y) + 10
      else
        d = d + 4 * x + 6
      end
    end
  end

  def draw_circle(c : Vec, r, color)
    draw_circle(c.x, c.y, r, color)
  end
end
