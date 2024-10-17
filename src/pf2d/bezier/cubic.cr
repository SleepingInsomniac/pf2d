require "../bezier"

module PF2d
  module Bezier
    # Cubic bezier is a type of spline segment with 4 control points.
    # The curve intersects points 0 and 3, while points 1 and 2 control the curve
    #
    # For information on the implementation see https://pomax.github.io/bezierinfo
    struct Cubic(T)
      include Aproximations

      def self.point(t : Float64, p0 : Number, p1 : Number, p2 : Number, p3 : Number)
        (1 - t) ** 3 * p0 + 3 * (1 - t) ** 2 * t * p1 + 3 * (1 - t) * t ** 2 * p2 + t ** 3 * p3
      end

      def self.derivative(t : Float64, p0 : Number, p1 : Number, p2 : Number, p3 : Number)
        3 * (1 - t) ** 2 * (p1 - p0) + 6 * (1 - t) * t * (p2 - p1) + 3 * t ** 2 * (p3 - p2)
      end

      def self.second_derivative(t : Float64, p0 : Number, p1 : Number, p2 : Number, p3 : Number)
        6 * (1 - t) * (p2 - 2 * p1 + p0) + 6 * t * (p3 - 2 * p2 + p1)
      end

      def self.extrema(p0 : Number, p1 : Number, p2 : Number, p3 : Number)
        a = 3 * (-p0 + 3 * p1 - 3 * p2 + p3)
        b = 6 * (p0 - 2 * p1 + p2)
        c = 3 * (p1 - p0)

        if a == 0
          if b != 0
            t = -c / b
            yield t if t >= 0 && t <= 1
          end
        else
          disc = b * b - 4 * a * c

          return unless disc >= 0

          disc_sqrt = Math.sqrt(disc)
          t1 = (-b + disc_sqrt) / (2 * a)
          t2 = (-b - disc_sqrt) / (2 * a)

          yield t1 if t1 >= 0 && t1 <= 1
          yield t2 if t2 >= 0 && t2 <= 1
        end
      end

      property p0 : Vec2(T)
      property p1 : Vec2(T)
      property p2 : Vec2(T)
      property p3 : Vec2(T)

      def initialize(@p0, @p1, @p2, @p3)
      end

      def points
        {pointerof(@p0), pointerof(@p1), pointerof(@p2), pointerof(@p3)}
      end

      # Get the point at percentage *t* < 0 < 1 of the curve
      def at(t : Float64)
        PF2d::Vec[
          T.new(self.class.point(t, @p0.x, @p1.x, @p2.x, @p3.x)),
          T.new(self.class.point(t, @p0.y, @p1.y, @p2.y, @p3.y)),
        ]
      end

      # Get the tangent to a point at *t* < 0 < 1 on the spline
      def tangent(t : Float64)
        PF2d::Vec[
          T.new(self.class.derivative(t, @p0.x, @p1.x, @p2.x, @p3.x)),
          T.new(self.class.derivative(t, @p0.y, @p1.y, @p2.y, @p3.y)),
        ].normalized
      end

      # Get the normal to a point at *t* < 0 < 1 on the spline
      def normal(t : Float64)
        PF2d::Vec[
          T.new(self.class.derivative(t, @p0.y, @p1.y, @p2.y, @p3.y)),
          T.new(-self.class.derivative(t, @p0.x, @p1.x, @p2.x, @p3.x)),
        ].normalized
      end

      # Get the points at the extremities of this curve
      # note: Will return 4 values which are either Float64 | nil
      def extrema
        self.class.extrema(@p0.x, @p1.x, @p2.x, @p3.x) { |et| yield at(et) }
        self.class.extrema(@p0.y, @p1.y, @p2.y, @p3.y) { |et| yield at(et) }
      end

      def rect
        tl, br = @p0, @p3

        tl.x = @p3.x if @p3.x < tl.x
        tl.y = @p3.y if @p3.y < tl.y
        br.x = @p0.x if @p0.x > br.x
        br.y = @p0.y if @p0.y > br.y

        extrema do |e|
          e = Vec2(T).new(T.new(e.x), T.new(e.y))
          tl.x = e.x if e.x < tl.x
          tl.y = e.y if e.y < tl.y
          br.x = e.x if e.x > br.x
          br.y = e.y if e.y > br.y
        end

        {tl, br}
      end

      def to_f64
        Cubic(Float64).new(p0.to_f64, p1.to_f64, p2.to_f64, p3.to_f64)
      end
    end
  end
end
