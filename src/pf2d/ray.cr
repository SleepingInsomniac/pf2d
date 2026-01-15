require "./vec"

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

    def project(x, y)
      project(Vec[x, y])
    end

    def project(p)
      (p - @pos).dot(@dir)
    end

    def at(t : Float)
      @pos + @dir * t
    end

    def intersect?(other)
      denominator = @dir.det(other.dir)
      return nil if denominator.abs <= 1e-9

      offset = other.pos - @pos

      t = offset.det(other.dir) / denominator
      u = offset.det(@dir) / denominator

      return nil unless t >= 0.0 && u >= 0.0

      @pos + @dir * t
    end
  end
end
