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
      (@p2 - @p1).normalized
    end

    # Find the normal axis to this line
    def normal
      Vec[-rise, run].normalized
    end

    # Normal counter clockwise
    def normal_cc
      Vec[rise, -run].normalized
    end

    # Return the point where the two lines would intersect unless parallel
    def intersects?(other : Line(T)) : Vec2(Float64)?
      x1, y1, x2, y2 = @p1.x, @p1.y, @p2.x, @p2.y
      x3, y3, x4, y4 = other.p1.x, other.p1.y, other.p2.x, other.p2.y

      denominator = (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4)

      return nil if denominator == 0.0

      px = (x1 * y2 - y1 * x2) * (x3 - x4) - (x1 - x2) * (x3 * y4 - y3 * x4)
      py = (x1 * y2 - y1 * x2) * (y3 - y4) - (y1 - y2) * (x3 * y4 - y3 * x4)

      Vec[px / denominator, py / denominator]
    end
  end
end
