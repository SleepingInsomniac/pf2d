require "../bezier"

module PF2d
  module Bezier
    # Cubic bezier is a type of spline segment with 4 control points.
    # The curve intersects points 0 and 3, while points 1 and 2 control the curve
    #
    # For information on the implementation see https://pomax.github.io/bezierinfo
    struct Cubic(T) < Curve(T)
      # Find the value at *t* along the curve (between 0.0 and 1.0)
      def self.interpolate(t : Float64, p0 : Number, p1 : Number, p2 : Number, p3 : Number)
        (1 - t) ** 3 * p0 + 3 * (1 - t) ** 2 * t * p1 + 3 * (1 - t) * t ** 2 * p2 + t ** 3 * p3
      end

      # The derivative represents the rate of change of the interpolation at *t*
      def self.derivative(t : Float64, p0 : Number, p1 : Number, p2 : Number, p3 : Number)
        3 * (1 - t) ** 2 * (p1 - p0) + 6 * (1 - t) * t * (p2 - p1) + 3 * t ** 2 * (p3 - p2)
      end

      def self.second_derivative(t : Float64, p0 : Number, p1 : Number, p2 : Number, p3 : Number)
        6 * (1 - t) * (p2 - 2 * p1 + p0) + 6 * t * (p3 - 2 * p2 + p1)
      end

      # Find the values that lie at the extrema of the function, i.e. where the rate of change is 0
      # these points are typically at the edges of a 2d curve
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

      # Solves roots so that t = 0
      def self.roots(p0 : Number, p1 : Number, p2 : Number, p3 : Number)
        # Compute coefficients a, b, c, d
        a = -p0 + 3 * p1 - 3 * p2 + p3
        b = 3 * p0 - 6 * p1 + 3 * p2
        c = -3 * p0 + 3 * p1
        d = p0

        epsilon = 1e-8

        if a.abs < epsilon
          # Quadratic case
          if b.abs < epsilon
            # Linear case
            if c.abs < epsilon
              # No solution
              return
            else
              t = -d / c
              yield t if t >= 0.0 && t <= 1.0

              return
            end
          else
            # Solve quadratic equation: b * t^2 + c * t + d = 0
            delta = c * c - 4 * b * d
            if delta.abs < epsilon
              t = -c / (2 * b)
              yield t if t >= 0.0 && t <= 1.0

              return
            elsif delta > 0
              sqrt_delta = Math.sqrt(delta)
              t1 = (-c + sqrt_delta) / (2 * b)
              yield t1 if t1 >= 0.0 && t1 <= 1.0
              t2 = (-c - sqrt_delta) / (2 * b)
              yield t2 if t2 >= 0.0 && t2 <= 1.0

              return
            end
          end
        else
          # Cubic case
          # Normalize coefficients
          coef_a = b / a
          coef_b = c / a
          coef_c = d / a

          # Compute p and q for depressed cubic
          p = coef_b - (coef_a * coef_a) / 3.0
          q = (2.0 * coef_a ** 3) / 27.0 - (coef_a * coef_b) / 3.0 + coef_c

          # Compute discriminant
          discriminant = (q / 2.0) ** 2 + (p / 3.0) ** 3

          discriminant = 0.0 if discriminant.abs < epsilon

          if discriminant > epsilon
            # One real root
            sqrt_disc = Math.sqrt(discriminant)
            u = cube_root(-q / 2.0 + sqrt_disc)
            v = cube_root(-q / 2.0 - sqrt_disc)
            x = u + v
            t = x - coef_a / 3.0

            yield t if t >= 0.0 && t <= 1.0
          elsif discriminant.abs < epsilon
            # Triple or double root
            u = cube_root(-q / 2.0)
            x1 = 2 * u
            x2 = -u
            t1 = x1 - coef_a / 3.0
            yield t1 if t1 >= 0.0 && t1 <= 1.0
            t2 = x2 - coef_a / 3.0
            yield t2 if t2 >= 0.0 && t2 <= 1.0 && (t2 - t1).abs > epsilon
          else
            # Three real roots
            phi = Math.acos(-q / (2.0 * Math.sqrt(-(p / 3.0) ** 3)))
            s = 2.0 * Math.sqrt(-p / 3.0)
            x1 = s * Math.cos(phi / 3.0)
            x2 = s * Math.cos((phi + 2.0 * Math::PI) / 3.0)
            x3 = s * Math.cos((phi + 4.0 * Math::PI) / 3.0)
            t1 = x1 - coef_a / 3.0
            t2 = x2 - coef_a / 3.0
            t3 = x3 - coef_a / 3.0
            {t1, t2, t3}.each do |t|
              yield t if t >= 0.0 && t <= 1.0
            end
          end
        end

        # If no roots found where t >= 0 && t <= 1
      end

      def self.cube_root(x : Number)
        if x >= 0.0
          x ** (1.0 / 3.0)
        else
          -((-x) ** (1.0 / 3.0))
        end
      end

      property p0 : Vec2(T)
      property p1 : Vec2(T)
      property p2 : Vec2(T)
      property p3 : Vec2(T)

      def initialize(@p0, @p1, @p2, @p3)
      end

      @[AlwaysInline]
      def point_pointers
        {pointerof(@p0), pointerof(@p1), pointerof(@p2), pointerof(@p3)}
      end

      @[AlwaysInline]
      def points
        {@p0, @p1, @p2, @p3}
      end

      @[AlwaysInline]
      def control_points : Tuple(Vec2(T), Vec2(T))
        {@p0, @p3}
      end
    end
  end
end
