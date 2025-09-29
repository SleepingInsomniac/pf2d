module PF2d
  module Bezier
    abstract struct Curve(T)
      abstract def points
      abstract def control_points : Tuple(Vec2(T), Vec2(T))

      @[AlwaysInline]
      def x_values
        points.map { |p| p.x }
      end

      @[AlwaysInline]
      def y_values
        points.map { |p| p.y }
      end

      # Get the point at percentage *t* < 0 < 1 of the curve
      def at(t : Float64) : Vec2(T)
        Vec[
          T.new(self.class.interpolate(t, *x_values)),
          T.new(self.class.interpolate(t, *y_values)),
        ]
      end

      # Get the tangent to a point at *t* < 0 < 1 on the spline
      def tangent(t : Float64)
        Vec[
          T.new(self.class.derivative(t, *x_values)),
          T.new(self.class.derivative(t, *y_values)),
        ].normalized
      end

      # Get the normal to a point at *t* < 0 < 1 on the spline
      def normal(t : Float64)
        PF2d::Vec[
          T.new(self.class.derivative(t, *y_values)),
          T.new(-self.class.derivative(t, *x_values)),
        ].normalized
      end

      # Get the points at the extrema of this curve
      def extrema(&)
        self.class.extrema(*x_values) { |et| yield at(et) }
        self.class.extrema(*y_values) { |et| yield at(et) }
      end

      # Get the length of the curve by calculating the length of line segments
      # Increase *steps* for accuracy
      def length(steps : UInt32 = 10)
        _length = 0.0
        seg_p0 = Vec[@p0.x, @p0.y]

        0.upto(steps) do |n|
          t = n / steps
          seg_p1 = at(t)
          _length += seg_p0.distance(seg_p1)
          seg_p0 = seg_p1
        end
        _length
      end

      def rect
        c1, c2 = control_points
        tl, br = c1, c2

        tl.x = c2.x if c2.x < tl.x
        tl.y = c2.y if c2.y < tl.y
        br.x = c1.x if c1.x > br.x
        br.y = c1.y if c1.y > br.y

        extrema do |e|
          e = Vec2(T).new(T.new(e.x), T.new(e.y))
          tl.x = e.x if e.x < tl.x
          tl.y = e.y if e.y < tl.y
          br.x = e.x if e.x > br.x
          br.y = e.y if e.y > br.y
        end

        Rect.new(tl, br - tl)
      end

      # The *t* value at which a line at *y* intercepts the curve
      def horizontal_intersects(y, &)
        # shift the points down so that y = 0
        self.class.roots(*y_values.map(&.-(y))) { |r| yield r }
      end

      macro inherited
        {% for method in %w[to_i to_u to_f
                           to_i8 to_i16 to_i32 to_i64 to_i128
                           to_u8 to_u16 to_u32 to_u64 to_u128
                           to_f32 to_f64
                         ] %}
        def {{ method.id }}
          {{ @type.name(generic_args: false) }}.new(*points.map(&.{{ method.id }}))
        end
      {% end %}
      end
    end
  end
end
