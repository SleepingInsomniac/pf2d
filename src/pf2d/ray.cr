module PF2d
  # Represents an infinite line by position *pos* and direction *dir*
  # dir should be normalized
  struct Ray(T)
    macro [](*args)
      PF2d::Ray.new({{args.splat}})
    end

    property pos : T
    property dir : T

    def initialize(@pos, @dir)
    end

    # Return the projection of the point *p* onto this ray
    # forms a right triangle with the ray and the line between p and the projection
    def project(p)
      (p - @pos).dot(@dir)
    end

    #:ditto:
    def project(x, y)
      project(Vec[x, y])
    end

    # Return the point at distance *t* along the ray
    def at(t : Float)
      @pos + @dir * t
    end

    def intersect?(other)
      denominator = @dir.det(other.dir)
      return nil if denominator.abs <= EPS

      offset = other.pos - @pos

      t = offset.det(other.dir) / denominator
      u = offset.det(@dir) / denominator

      return nil unless t >= 0.0 && u >= 0.0

      @pos + @dir * t
    end

    def closest_point(p)
      t = project(p)
      t = 0.0 if t < 0.0
      at(t)
    end

    def distance_to(p)
      (p - closest_point(p)).magnitude
    end

    def normal
      Ray[@pos, @dir.normal]
    end

    def to_line(t : Float64)
      Line[@pos, @pos + @dir * t]
    end
  end
end
