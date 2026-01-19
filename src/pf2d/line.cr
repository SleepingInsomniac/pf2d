module PF2d
  # Represents a line between two points
  # `Line(Vec(Int32, 2))`
  #
  struct Line(T)
    macro [](*args)
      PF2d::Line.new({{args.splat}})
    end

    property p1 : T, p2 : T

    def initialize(@p1, @p2)
    end

    def initialize(x1, y1, x2, p2)
      @p1 = Vec[x1, y1]
      @p2 = Vec[x2, y2]
    end

    def point_pointers
      {pointerof(@p1), pointerof(@p2)}
    end

    # The height from the starting point to the ending point
    #
    def rise
      @p2.y - @p1.y
    end

    # The length from the starting point to the ending point
    #
    def run
      @p2.x - @p1.x
    end

    def slope
      return 0.0 if run == 0
      rise / run
    end

    def inv_slope
      return 0.0 if rise == 0
      run / rise
    end

    def left
      @p1.x < @p2.x ? @p1.x : @p2.x
    end

    def right
      @p1.x > @p2.x ? @p1.x : @p2.x
    end

    def top
      @p1.y > @p2.y ? @p2.y : @p1.y
    end

    def bottom
      @p1.y > @p2.y ? @p1.y : @p2.y
    end

    def contains_y?(y)
      if @p1.y < @p2.y
        top, bottom = @p1.y, @p2.y
      else
        top, bottom = @p2.y, @p1.y
      end

      y >= top && y <= bottom
    end

    def y_at(x)
      return p1.y if slope == 1.0
      x * slope + p1.y
    end

    def x_at(y)
      return p1.x if slope == 0.0
      (y - p1.y) / slope + p1.x
    end

    # Linearly interpolate
    def lerp(t : Float64)
      (@p2 - @p1) * t + @p1
    end

    # Return the length of the line
    def length
      Math.sqrt(((@p2 - @p1) ** 2).sum)
    end

    def /(n : (Float | Int))
      Line.new(@p1 / n, @p2 / n)
    end

    # Convert this line into a normalized vector
    def to_vector
      direction.normalized
    end

    def direction
      @p2 - @p1
    end

    # Find the normal axis to this line
    def normal
      Vec[-rise, run].normalized
    end

    # Normal counter clockwise
    def normal_cc
      Vec[rise, -run].normalized
    end

    def rect
      tl = Vec[left, top]
      br = Vec[right, bottom]
      Rect[tl, br - tl]
    end

    # Return the point where the two lines intersect unless parallel
    def intersect?(other : Line)
      d1, d2 = direction, other.direction
      offset = other.p1 - @p1
      denominator = d1.det(d2)

      return nil if denominator.abs <= 1e-9

      t = offset.det(d2) / denominator
      u = offset.det(d1) / denominator

      return nil unless (0.0 <= t && t <= 1.0 &&
                         0.0 <= u && u <= 1.0)

      @p1 + d1 * t
    end

    # Return the point where the two lines would intersect unless parallel
    def unbounded_intersect?(other : Line)
      d1, d2 = direction, other.direction
      denominator = d1.det(d2)

      return nil if denominator.abs <= 1e-9

      p = d2 * @p2.det(@p1) - d1 * other.p2.det(other.p1)
      p / denominator
    end

    # Return the point where the two lines would intersect unless parallel
    @[Deprecated("Use #intersect?")]
    def intersects?(other : Line(T))
      intersect?(other)
    end
  end
end
