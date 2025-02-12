module PF2d::Drawable(T)
  @tbt = PF2d::ThreadedBinaryTree(Tuple(UInt16, PF2d::Vec2(Float64))).new { |(x1, _d1), (x2, _d2)| x1 < x2 ? -1 : 1 }

  # Fills a spline by even-odd shape filling for each scan line
  @[Experimental]
  def fill_spline(spline : QuadSpline, color)
    rect = spline.closed_rect
    # Get the full bounding box of the closed spline
    # Iterate through each y value from top to bottom
    rect.top.to_i.upto(rect.bottom.to_i) do |y|
      @tbt.clear
      # For each curve in the closed spline...
      spline.closed_curves do |curve|
        # Calculate the t value for the intersection at y in the curve
        curve.horizontal_intersects(y) do |t|
          # Get the x value of the intersection
          x = curve.at(t).x.to_u16
          # Get the direction of the tangent at the intersection
          # This will be used later to determine if we're inside or outside the closed spline
          dir = curve.tangent(t)

          # Insert the x intercept and direction into the threaded binary tree (sorted by x position)
          @tbt << {x, dir}
        end
      end

      drawing = true

      @tbt.each_cons_pair do |(x1, d1), (x2, d2)|
        scan_line(x1, y, x2 - x1, color) if drawing
        drawing = !drawing
      end
    end
  end
end
