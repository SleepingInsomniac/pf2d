module PF2d::Drawable(T)
  private def sort_verticies(p1 : PF2d::Vec, p2 : PF2d::Vec, p3 : PF2d::Vec)
    # Sort points from top to bottom
    p1, p2 = p2, p1 if p2.y < p1.y
    p1, p3 = p3, p1 if p3.y < p1.y
    p2, p3 = p3, p2 if p3.y < p2.y
    {p1, p2, p3}
  end

  private def sort_verticies(p1 : PF2d::Vec, p2 : PF2d::Vec, p3 : PF2d::Vec, t1 : PF2d::Vec, t2 : PF2d::Vec, t3 : PF2d::Vec)
    # Sort points from top to bottom
    p1, p2, t1, t2 = p2, p1, t2, t1 if p2.y < p1.y
    p1, p3, t1, t3 = p3, p1, t3, t1 if p3.y < p1.y
    p2, p3, t2, t3 = p3, p2, t3, t2 if p3.y < p2.y
    {p1, p2, p3, t1, t2, t3}
  end

  # Draw a filled in triangle
  def fill_triangle(p1 : PF2d::Vec, p2 : PF2d::Vec, p3 : PF2d::Vec, color)
    p1, p2, p3 = sort_verticies(p1, p2, p3)

    # sort left and right edges by run / rise
    line_left = PF2d::Line.new(p1, p2)
    line_right = PF2d::Line.new(p1, p3)

    if line_left.run / line_left.rise > line_right.run / line_right.rise
      line_left, line_right = line_right, line_left
    end

    # calculate line slopes
    slope_left = line_left.slope
    slope_right = line_right.slope

    offset = p1.y        # height offset from 0
    height = p3.y - p1.y # height of the triangle
    mid = p2.y - p1.y    # where the flat bottom triangle ends

    start = 0
    fin = mid

    # Draw the triangle in two halfs
    # 0 - Flat bottom triangle
    # 1 - Flat top triangle
    2.times do |half|
      start.upto(fin) do |y|
        if slope_left == 0
          # When there is no rise, set the x value directly
          x_left = line_left.p2.x
        else
          x_left = ((y - (line_left.p1.y - p1.y)) / slope_left).round.to_i + line_left.p1.x
        end

        if slope_right == 0
          x_right = line_right.p2.x
        else
          x_right = ((y - (line_right.p1.y - p1.y)) / slope_right).round.to_i + line_right.p1.x
        end

        x_left.upto(x_right) do |x|
          draw_point(x, y + offset, color)
        end
      end

      start = fin + 1
      fin = height

      # Depending on which point is the middle
      if line_left.p2 == p2
        line_left = PF2d::Line.new(p2, p3)
        slope_left = line_left.slope
      else
        line_right = PF2d::Line.new(p2, p3)
        slope_right = line_right.slope
      end
    end
  end

  # ditto
  def fill_triangle(points : Enumerable(PF2d::Vec), color)
    fill_triangle(points[0], points[1], points[2], color)
  end
end
