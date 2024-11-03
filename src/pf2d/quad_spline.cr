module PF2d
  # Quadratic spline
  # It is assumed that every other point is an off-curve point starting with an on-curve point
  struct QuadSpline(T)
    property points : Enumerable(Vec2(T))

    def initialize
      @points = [] of Vec2(T)
    end

    def initialize(@points)
    end

    def initialize(*@points)
    end

    # Yield quad curves for each set of 3 points
    def curves
      (0..@points.size - 3).step(2) do |i|
        yield Bezier::Quad.new(@points[i], @points[i + 1], @points[i + 2])
      end
    end

    # Yield quad curves for each set of 3 points, wrapping to the beginning
    def closed_curves
      (0..@points.size - 2).step(2) do |i|
        yield Bezier::Quad.new(@points[i], @points[i + 1], @points[(i + 2) % @points.size])
      end
    end
  end
end
