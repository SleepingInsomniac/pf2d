module PF2d
  struct Tri(T)
    macro [](*args)
      PF2d::Tri.new({{args.splat}})
    end

    property p1 : Vec2(T)
    property p2 : Vec2(T)
    property p3 : Vec2(T)

    def initialize(@p1 : Vec2(T), @p2 : Vec2(T), @p3 : Vec2(T))
    end

    def points
      {@p1, @p2, @p3}
    end

    def point_pointers
      {pointerof(@p1), pointerof(@p2), pointerof(@p3)}
    end

    {% for op in %w[* / // + - % **] %}
      # Applies `{{op.id}}` to all component of this Vec with the corresponding component of *other*
      def {{ op.id }}(vec : Vec2)
        Tri[p1 {{op.id}} vec, p2 {{op.id}} vec, p3 {{op.id}} vec]
      end
    {% end %}

    def barycentric?(p : Vec2(Number))
      v0 = p2 - p1
      v1 = p3 - p1
      v2 = p - p1
      denom = v0.det(v1)

      return nil if denom.abs <= EPS # no surface area

      u = v2.det(v1) / denom
      v = v0.det(v2) / denom

      {1.0 - u - v, u, v}
    end

    def lines
      {Line[p1, p2], Line[p2, p3], Line[p3, p1]}
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

    # Maps points from self to *dest* with affine interpolation
    # useful for sampling textures
    def map_points(dest : Tri(Number), q0 : Float = 1.0, q1 : Float = 1.0, q2 : Float = 1.0)
      min_y.to_i.upto(max_y.ceil.to_i) do |y|
        min_x.to_i.upto(max_x.ceil.to_i) do |x|
          p = Vec[x, y]
          w = barycentric?(p)

          next if w.nil?

          b0, b1, b2 = w
          next if b0 < -EPS || b1 < -EPS || b2 < -EPS

          q  = b0 * q0 + b1 * q1 + b2 * q2
          next if q.abs <= EPS

          sp_num =
            (dest.p1 * (b0 * q0)) +
            (dest.p2 * (b1 * q1)) +
            (dest.p3 * (b2 * q2))

          sp = sp_num / q

          yield sp, p
        end
      end
    end
  end
end
