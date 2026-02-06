module PF2d
  module Bezier
    struct Quad(T) < Curve(T)
      def self.interpolate(t : Float64, p1 : Number, p2 : Number, p3 : Number)
        (1 - t) ** 2 * p1 + 2 * (1 - t) * t * p2 + t ** 2 * p3
      end

      def self.derivative(t : Float64, p1 : Number, p2 : Number, p3 : Number)
        (-2 + 2 * t) * p1 + (2 - 4 * t) * p2 + 2 * t * p3
      end

      def self.second_derivative(p1 : Number, p2 : Number, p3 : Number)
        2 * p1 - 4 * p2 + 2 * p3
      end

      def self.extrema(p1 : Number, p2 : Number, p3 : Number)
        numerator = p1 - p2
        denominator = p1 - 2 * p2 + p3
        return if denominator == 0.0

        t_extrema = numerator / denominator

        return unless t_extrema >= 0.0 && t_extrema <= 1.0

        yield t_extrema
      end

      # Solves roots so that t = 0
      def self.roots(p1 : Number, p2 : Number, p3 : Number)
        # Compute coefficients of the quadratic equation a*t^2 + b*t + c = 0
        a = p1 - 2.0 * p2 + p3
        b = -2.0 * p1 + 2.0 * p2
        c = p1

        if a.abs < EPS
          # Linear case: a is approximately zero
          if b.abs < EPS
            # Degenerate case: both a and b are approximately zero
            # No solution unless c is also approximately zero
            yield 0.0 if c.abs < EPS
          else
            # Solve linear equation b * t + c = 0
            t = -c / b
            yield t if t >= 0.0 && t <= 1.0
          end
        else
          # Quadratic case
          discriminant = b ** 2 - 4.0 * a * c

          if discriminant.abs < EPS
            # One real root
            t = -b / (2.0 * a)
            yield t if t >= 0.0 && t <= 1.0
          elsif discriminant > EPS
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

      property p1 : Vec2(T)
      property p2 : Vec2(T)
      property p3 : Vec2(T)

      def initialize(@p1, @p2, @p3)
      end

      def initialize(x0 : T, y0 : T, x1 : T, y1 : T, x2 : T, y2 : T)
        @p1 = Vec[x0, y0]
        @p2 = Vec[x1, y1]
        @p3 = Vec[x2, y2]
      end

      def point_pointers
        {pointerof(@p1), pointerof(@p2), pointerof(@p3)}
      end

      def points
        {@p1, @p2, @p3}
      end

      def control_point_pointers : Tuple(Vec2(T)*, Vec2(T)*)
        {pointerof(@p1), pointerof(@p3)}
      end

      def control_points : Tuple(Vec2(T), Vec2(T))
        {@p1, @p3}
      end

      # Split this curve into two curves at *t*
      def split(t : Float64)
        p12 = Line[@p1, @p2].lerp(t)
        p23 = Line[@p2, @p3].lerp(t)
        p12_23 = Line[p12, p23].lerp(t)

        {
          Quad.new(@p1.to(T), p12.to(T), p12_23.to(T)),
          Quad.new(p1223.to(T), p23.to(T), @p3.to(T)),
        }
      end
    end
  end
end
