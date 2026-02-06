module PF2d::Drawable(T)
  # Draw a line using Bresenham’s Algorithm
  def draw_line(x1 : Int, y1 : Int, x2 : Int, y2 : Int, color)
    # The slope for each axis
    slope = PF2d::Vec[(x2 - x1).abs, -(y2 - y1).abs]

    # The step direction in both axis
    step = PF2d::Vec[x1 < x2 ? 1 : -1, y1 < y2 ? 1 : -1]

    # The final decision accumulation
    # Initialized to the height of x and y
    decision = slope.x + slope.y

    point = PF2d::Vec[x1, y1]

    loop do
      draw_point(point.x, point.y, color)
      # Break if we've reached the ending point
      break if point.x == x2 && point.y == y2

      # Square the decision to avoid floating point calculations
      decision_squared = decision + decision

      # if decision_squared is greater than
      if decision_squared >= slope.y
        decision += slope.y
        point.x += step.x
      end

      if decision_squared <= slope.x
        decision += slope.x
        point.y += step.y
      end
    end
  end

  # :ditto:
  def draw_line(x1 : Number, y1 : Number, x2 : Number, y2 : Number, color)
    draw_line(x1.to_i32, y1.to_i32, x2.to_i32, y2.to_i32, color)
  end

  # :ditto:
  def draw_line(p1 : PF2d::Vec, p2 : PF2d::Vec, color)
    draw_line(p1.x, p1.y, p2.x, p2.y, color)
  end

  # :ditto:
  def draw_line(line : PF2d::Line, color)
    draw_line(line.p1.x, line.p1.y, line.p2.x, line.p2.y, color)
  end

  # :ditto:
  def draw(line : PF2d::Line, color)
    draw_line(line, color)
  end

  # :ditto:
  def draw_line(points : Enumerable(PF2d::Vec), color)
    points.each_cons(2) do |(p1, p2)|
      draw_line(p1, p2, color)
    end
  end

  # :ditto:
  def draw(lines : Enumerable(PF2d::Line), color)
    lines.each do |line|
      draw_line(line, color)
    end
  end

  # Draw a horizontal line of *width*
  def scan_line(x : Number, y : Number, width : Number, color)
    0.upto(width.to_i) { |n| draw_point(x + n, y, color) }
  end
end
