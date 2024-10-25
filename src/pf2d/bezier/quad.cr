module PF2d
  module Bezier
    struct Quad(T) < Curve(T)
      def self.interpolate(t : Float64, p0 : Number, p1 : Number, p2 : Number)
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

      # Solves roots so that t = 0
      def self.roots(p0 : Number, p1 : Number, p2 : Number)
        # Compute coefficients of the quadratic equation a*t^2 + b*t + c = 0
        a = p0 - 2.0 * p1 + p2
        b = -2.0 * p0 + 2.0 * p1
        c = p0

        epsilon = 1e-8

        if a.abs < epsilon
          # Linear case: a is approximately zero
          if b.abs < epsilon
            # Degenerate case: both a and b are approximately zero
            # No solution unless c is also approximately zero
            yield 0.0 if c.abs < epsilon
          else
            # Solve linear equation b * t + c = 0
            t = -c / b
            yield t if t >= 0.0 && t <= 1.0
          end
        else
          # Quadratic case
          discriminant = b ** 2 - 4.0 * a * c

          if discriminant.abs < epsilon
            # One real root
            t = -b / (2.0 * a)
            yield t if t >= 0.0 && t <= 1.0
          elsif discriminant > epsilon
            # Two real roots
            sqrt_discriminant = Math.sqrt(discriminant)
            t1 = (-b + sqrt_discriminant) / (2.0 * a)
            yield t1 if t1 >= 0.0 && t1 <= 1.0
            t2 = (-b - sqrt_discriminant) / (2.0 * a)
            yield t2 if t2 >= 0.0 && t2 <= 1.0
          end
          # If discriminant < 0, no real roots
        end
      end

      property p0 : Vec2(T)
      property p1 : Vec2(T)
      property p2 : Vec2(T)

      def initialize(@p0, @p1, @p2)
      end

      @[AlwaysInline]
      def point_pointers
        {pointerof(@p0), pointerof(@p1), pointerof(@p2)}
      end

      @[AlwaysInline]
      def points
        {@p0, @p1, @p2}
      end

      @[AlwaysInline]
      def control_point_pointers : Tuple(Vec2(T)*, Vec2(T)*)
        {pointerof(@p0), pointerof(@p2)}
      end

      @[AlwaysInline]
      def control_points : Tuple(Vec2(T), Vec2(T))
        {@p0, @p2}
      end

      # Split this curve into two curves at *t*
      def split(t : Float64)
        p01 = Line[@p0, @p1].lerp(t)
        p12 = Line[@p1, @p2].lerp(t)
        p012 = Line[p01, p12].lerp(t)

        {
          Quad.new(@p0.to(T), p01.to(T), p012.to(T)),
          Quad.new(p012.to(T), p12.to(T), @p2.to(T)),
        }
      end
    end
  end
end
