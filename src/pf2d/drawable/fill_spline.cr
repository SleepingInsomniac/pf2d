module PF2d::Drawable(T)
  EPSILON = 1e-6

  record Intercept, x : Float64, d : PF2d::Vec2(Float64)
  @tbt = PF2d::ThreadedBinaryTree(Intercept).new { |v1, v2| v1.x > v2.x ? 1 : -1 }

  # Fills a spline by the clockwise winding rule
  @[Experimental("Edge cases are not covered")]
  def fill_spline(spline : QuadSpline, color)
    fill_splines({spline}, color)
  end

  # :ditto:
  @[Experimental("Edge cases are not covered")]
  def fill_splines(splines : Enumerable(QuadSpline), color)
    return if splines.empty?

    # Get the full bounding box of the closed splines
    rect = splines.reduce(splines.first.closed_rect) { |rect, spline| rect.merge(spline.closed_rect) }

    # Iterate through each y value from top to bottom
    rect.top.to_i.upto(rect.bottom.to_i) do |y|
      @tbt.clear
      # For each curve in the closed spline...
      splines.each do |spline|
        spline.closed_curves do |curve|
          # Calculate the t value for the intersection at y in the curve
          curve.horizontal_intersects(y) do |t|
            # Get the x value of the intersection
            x = curve.at(t).x
            # Get the direction of the tangent at the intersection
            # This will be used later to determine if we're inside or outside the closed spline
            dir = curve.tangent(t)

            # Insert the x intercept and direction into the threaded binary tree (sorted by x position)
            @tbt << Intercept.new(x, dir)
          end
        end
      end

      winding = 0 # Count the number of times we cross the curve

      @tbt.each_cons_pair do |i1, i2|
        winding += 1 if i1.d.y < -EPSILON
        winding -= 1 if i1.d.y > EPSILON

        if winding > 0
          scan_line(i1.x, y, (i2.x - i1.x), color)
        end
      end
    end
  end
end
