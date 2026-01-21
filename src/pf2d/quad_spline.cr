module PF2d
  # Quadratic spline
  # It is assumed that every other point is an off-curve point starting with an on-curve point
  struct QuadSpline(T)
    property points : Indexable::Mutable(Vec2(T))

    def initialize
      @points = [] of Vec2(T)
    end

    def initialize(@points)
    end

    def initialize(*points : Vec2(T))
      @points = points
    end

    # Yield quad curves for each set of 3 points
    def curves(&)
      (0..@points.size - 3).step(2) do |i|
        yield Bezier::Quad.new(@points[i], @points[i + 1], @points[i + 2])
      end
    end

    # Yield quad curves for each set of 3 points, wrapping to the beginning
    def closed_curves(&)
      (0..@points.size - 2).step(2) do |i|
        yield Bezier::Quad.new(@points[i], @points[i + 1], @points[(i + 2) % @points.size])
      end
    end

    def rect
      top_left = @points.first
      bottom_right = top_left
      curves do |curve|
        rect = curve.rect
        top_left.x = rect.top_left.x if rect.top_left.x < top_left.x
        top_left.y = rect.top_left.y if rect.top_left.y < top_left.y
        bottom_right.x = rect.bottom_right.x if rect.bottom_right.x > bottom_right.x
        bottom_right.y = rect.bottom_right.y if rect.bottom_right.y > bottom_right.y
      end
      Rect.new(top_left, bottom_right - top_left + 1)
    end

    def closed_rect
      top_left = @points.first
      bottom_right = top_left
      closed_curves do |curve|
        rect = curve.rect
        top_left.x = rect.top_left.x if rect.top_left.x < top_left.x
        top_left.y = rect.top_left.y if rect.top_left.y < top_left.y
        bottom_right.x = rect.bottom_right.x if rect.bottom_right.x > bottom_right.x
        bottom_right.y = rect.bottom_right.y if rect.bottom_right.y > bottom_right.y
      end
      Rect.new(top_left, bottom_right - top_left + 1)
    end

    {% for op in %w[* / // + - % **] %}
      # Applies `{{op.id}}` to all points in this spline
      def {{ op.id }}(value)
        QuadSpline.new(@points.map(&.{{ op.id }}(value)))
      end
    {% end %}

    def horizontal_intersects(y, &)
      closed_curves do |curve|
        curve.horizontal_intersects(y) do |t|
          yield curve, t
        end
      end
    end

    def merge(other)
      QuadSpline.new(@points.concat(other.points))
    end
  end
end
