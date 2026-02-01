module PF2d::Drawable(T)
  record Intercept, x : Float64, d : PF2d::Vec2(Float64)
  @tbt = PF2d::ThreadedBinaryTree(Intercept).new { |v1, v2| v1.x > v2.x ? 1 : -1 }
  @intercept_group = [] of Intercept

  # Fills a spline by the clockwise winding rule
  def fill_spline(spline : QuadSpline, color)
    fill_splines({spline}, color)
  end

  # :ditto:
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

      next if @tbt.empty?
      @intercept_group.clear
      current_intercept = @tbt.first.value

      @tbt.each do |intercept|
        if intercept.x == current_intercept.x
          @intercept_group << intercept # Accumulate same x values into a group to evaluate the winding
        else
          winding += 1 if @intercept_group.any? { |i| i.d.y < -EPS } && @intercept_group.none? { |i| i.d.y > 0 }
          winding -= 1 if @intercept_group.any? { |i| i.d.y > EPS } && @intercept_group.none? { |i| i.d.y < 0 }

          x1 = current_intercept.x
          x2 = (intercept.x - current_intercept.x)

          scan_line(x1, y, x2, color) if winding > 0
          @intercept_group.clear
          @intercept_group << intercept
        end

        current_intercept = intercept
      end
    end
  end
end
