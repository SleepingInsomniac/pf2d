module PF2d
  module Bezier
    struct Quad(T)
      include Aproximations

      def self.point(t : Float64, p0 : Number, p1 : Number, p2 : Number)
        (1 - t) ** 2 * p0 + 2 * (1 - t) * t * p1 + t ** 2 * p2
      end

      def self.derivative(t : Float64, p0 : Number, p1 : Number, p2 : Number)
        (-2 + 2 * t) * p0 + (2 - 4 * t) * p1 + 2 * t * p2
      end

      def self.second_derivative(p0 : Number, p1 : Number, p2 : Number)
        2 * p0 - 4 * p1 + 2 * p2
      end

      def self.extrema(p0 : Number, p1 : Number, p2 : Number)
        numerator = p0 - p1
        denominator = p0 - 2 * p1 + p2
        return if denominator == 0.0

        t_extrema = numerator / denominator

        return unless t_extrema >= 0.0 && t_extrema <= 1.0

        yield t_extrema
      end

      property p0 : Vec2(T)
      property p1 : Vec2(T)
      property p2 : Vec2(T)

      def initialize(@p0, @p1, @p2)
      end

      def points
        {pointerof(@p0), pointerof(@p1), pointerof(@p2)}
      end

      # Get the point at percentage *t* of the curve
      def at(t : Float64)
        PF2d::Vec[
          self.class.point(t, @p0.x, @p1.x, @p2.x),
          self.class.point(t, @p0.y, @p1.y, @p2.y),
        ]
      end

      # Get the tangent to a point at *t* < 0 < 1 on the spline
      def tangent(t : Float64)
        PF2d::Vec[
          T.new(self.class.derivative(t, @p0.x, @p1.x, @p2.x)),
          T.new(self.class.derivative(t, @p0.y, @p1.y, @p2.y)),
        ].normalized
      end

      # Get the normal to a point at *t* < 0 < 1 on the spline
      def normal(t : Float64)
        PF2d::Vec[
          T.new(self.class.derivative(t, @p0.y, @p1.y, @p2.y)),
          T.new(-self.class.derivative(t, @p0.x, @p1.x, @p2.x)),
        ].normalized
      end

      def extrema
        self.class.extrema(@p0.x, @p1.x, @p2.x) { |et| yield at(et) }
        self.class.extrema(@p0.y, @p1.y, @p2.y) { |et| yield at(et) }
      end

      def rect
        tl, br = @p0, @p2

        tl.x = @p2.x if @p2.x < tl.x
        tl.y = @p2.y if @p2.y < tl.y
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
        Quad(Float64).new(p0.to_f64, p1.to_f64, p2.to_f64)
      end
    end
  end
end
