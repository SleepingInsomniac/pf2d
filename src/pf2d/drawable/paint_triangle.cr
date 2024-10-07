module PF2d::Drawable(T)
  # Draw a textured triangle
  def paint_triangle(p1 : PF2d::Vec, p2 : PF2d::Vec, p3 : PF2d::Vec, t1 : PF2d::Vec, t2 : PF2d::Vec, t3 : PF2d::Vec, texture : PF2d::Viewable(T)?, buffer : Drawable(Float), tint : T)
    p1, p2, p3, t1, t2, t3 = sort_verticies(p1, p2, p3, t1, t2, t3)

    # z = (p1.z + p2.z + p3.z) // 3
    z = p1.z

    # Create lines starting at p1 to the other lower points
    line_left = PF2d::Line.new(p1, p2)
    line_right = PF2d::Line.new(p1, p3)
    tl_left = PF2d::Line.new(t1, t2)
    tl_right = PF2d::Line.new(t1, t3)

    # Sort left and right edges by run / rise
    # if the first line goes to the right more than the right, then swap (first line is on the right)
    if line_left.run / line_left.rise > line_right.run / line_right.rise
      line_left, line_right = line_right, line_left
      tl_left, tl_right = tl_right, tl_left
    end

    # if the left line ends at the middle, the left line changes
    # otherwise this will be false and the right line will change
    switch_left = line_left.p2 == p2

    # calculate line slopes
    slope_left = line_left.slope
    slope_right = line_right.slope

    c = p1.y             # offset from 0
    height = p3.y - p1.y # triangle height
    mid = p2.y - p1.y    # where the shorter line ends

    start = 0
    fin = mid

    # Draw the triangle in two halfs
    # 0 - Flat bottom triangle
    # 1 - Flat top triangle
    2.times do |half|
      start.upto(fin) do |y|
        # Check if the slope is 0, this would cause a divide by 0
        if slope_left == 0
          # When there is no rise, set the x value directly
          x_left = line_left.p2.x
        else
          x_left = ((y - (line_left.p1.y - p1.y)) / slope_left).round.to_i + line_left.p1.x
        end

        if slope_right == 0
          x_right = line_right.p2.x
          t_right = tl_right.p2.x
        else
          x_right = ((y - (line_right.p1.y - p1.y)) / slope_right).round.to_i + line_right.p1.x
        end

        # Get the normalized t value for this height level
        ty = height > 0 ? y / height : 0.0

        # LERP both texture edges at the y position to create a new line
        tyl =
          if switch_left
            # Line left is the 2 part segment
            if half == 0
              # still in the first segment (percent over the midpoint)
              mid == 0 ? 0.0 : y / mid
            else
              # in the second part, pecentage of middle to end
              height == 0 ? 0.0 : (y - mid) / (height - mid)
            end
          else
            height == 0 ? 0.0 : y / height
          end

        tyr =
          unless switch_left
            if half == 0
              mid == 0 ? 1.0 : y / mid
            else
              height == 0 ? 1.0 : (y - mid) / (height - mid)
            end
          else
            height == 0 ? 1.0 : y / height
          end

        texture_line = PF2d::Line.new(tl_left.lerp(tyl), tl_right.lerp(tyr))

        # Get the width of the scan line
        scan_size = x_right - x_left

        x_left.upto(x_right) do |x|
          # LERP the line between the texture edges
          t = scan_size == 0 ? 0.0 : (x - x_left) / scan_size
          texture_point = texture_line.lerp(t)

          if texture_point.z > buffer[x, y + c]
            buffer[x, y + c] = texture_point.z

            if tx = texture
              # Get the x and y of the texture coords, divide by z for perspective, then
              # multiply the point by the size of the texture to get the final texture point
              sample_point = ((PF2d::Vec[texture_point.x, texture_point.y] / texture_point.z) * texture.size)
              # Invert the y axis for the sprite
              sample_point.y = texture.height - sample_point.y
              sample_point %= texture.size

              color = texture.get_point(sample_point.to_i)

              # Blend the color sample with the provided color
              color = color.darken(tint)
            else
              color = tint
            end

            # Darken by distance
            d = (((50.0 - z) / 100.0) + 0.5).clamp(0.0..1.0)
            color *= d

            draw_point(x, y + c, color)
          end
        end
      end

      start = fin + 1
      fin = height

      # Once we hit the point where a line changes, we need a new slope for that line
      if switch_left
        line_left = PF2d::Line.new(p2, p3)
        tl_left = PF2d::Line.new(t2, t3)
        slope_left = line_left.slope
      else
        line_right = PF2d::Line.new(p2, p3)
        tl_right = PF2d::Line.new(t2, t3)
        slope_right = line_right.slope
      end
    end
  end
end
