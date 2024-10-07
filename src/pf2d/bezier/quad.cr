module PF2d
  module Bezier
    struct Quad(T)
      include Aproximations

      def self.point(t : Float64, p0 : Number, p1 : Number, p2 : Number)
        (1 - t) ** 2 * p0 + 2 * (1 - t) * t * p1 + t ** 2 * p2
      end

      property p0 : PF2d::Vec2(T)
      property p1 : PF2d::Vec2(T)
      property p2 : PF2d::Vec2(T)

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

      def to_f64
        Quad(Float64).new(p0.to_f64, p1.to_f64, p2.to_f64)
      end
    end
  end
end
