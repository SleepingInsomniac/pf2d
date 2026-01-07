module PF2d
  struct Tri(T)
    property p1 : Vec2(T)
    property p2 : Vec2(T)
    property p3 : Vec2(T)

    def initialize(@p1 : Vec2(T), @p2 : Vec2(T), @p3 : Vec2(T))
    end

    def barycentric(p : Vec2(Number))
      v0 = p2 - p1
      v1 = p3 - p1
      v2 = p - p1
      denom = v0.det(v1)

      return nil if denom.abs <= 1e-12 # no surface area

      u = v2.det(v1) / denom
      v = v0.det(v2) / denom

      {1.0 - u - v, u, v}
    end

    def min_x
      {p1.x, p2.x, p3.x}.min
    end

    def max_x
      {p1.x, p2.x, p3.x}.max
    end

    def min_y
      {p1.y, p2.y, p3.y}.min
    end

    def max_y
      {p1.y, p2.y, p3.y}.max
    end

    def map_points(dest : Tri(Number))
      min_y.floor.to_i.upto(max_y.ceil.to_i) do |y|
        min_x.floor.to_i.upto(max_x.ceil.to_i) do |x|
          p = Vec[x + 0.5, y + 0.5]
          w = barycentric(p)

          next if w.nil?

          w0, w1, w2 = w

          next if w0 < -1e-9 || w1 < -1e-9 || w2 < -1e-9

          sp = dest.p1 * w0 + dest.p2 * w1 + dest.p3 * w2
          dp = [x.to_f, y.to_f]

          yield sp, dp
        end
      end
    end
  end
end
