module PF2d
  struct Vec(T)
    macro [](*args)
      PF2d::Vec(typeof({{args.splat}})).new({{args.splat}})
    end

    property x : T
    property y : T

    def initialize(@x, @y)
    end

    {% for op in %w[> < >= <= ==] %}
      # Tests if all components of each vector meet the `{{op.id}}` condition
      def {{ op.id }}(other : Vec)
        @x {{op.id}} other.x && @y {{op.id}} other.y
      end

      # Tests if all components of this vector meet the `{{op.id}}` condition with the given *n*
      def {{ op.id }}(n : (Int | Float))
        @x {{op.id}} n && @y {{op.id}} n
      end
    {% end %}

    {% for op in %w[- abs] %}
      # Calls `{{ op.id }}` on all components of this vector
      def {{op.id}}
        Vec[@x.{{op.id}}, @y.{{op.id}}]
      end
    {% end %}

    {% for op in %w[* / // + - % **] %}
      # Applies `{{op.id}}` to all component of this vector with the corresponding component of *other*
      def {{ op.id }}(other : Vec)
        Vec[@x {{op.id}} other.x, @y {{op.id}} other.y]
      end

      # Applies `{{op.id}}` to all component of this vector with *n*
      def {{ op.id }}(n : (Int | Float))
        Vec[@x {{op.id}} n, @y {{op.id}} n]
      end
    {% end %}

    # Add all components together
    def sum
      @x + @y
    end

    # The length or magnitude of the vector calculated by the Pythagorean theorem
    def magnitude
      Math.sqrt(@x ** 2 + @y ** 2)
    end

    # Returns a new normalized unit `Vector{{i}}`
    def normalized
      m = magnitude
      return self if m == 0
      i = (1.0 / m)
      Vec[@x * i, @y * i]
    end

    # Returns the dot product of this vector and *other*
    def dot(other : Vec)
      @x * other.x + @y * other.y
    end

    # Calculates the cross product of this vector and *other*
    def cross(other : Vec)
      Vec[
        x * other.y - y * other.x,
        y * other.x - x * other.y,
      ]
    end

    # Returns normalized value at a normal to the current vector
    def normal(other : Vec)
      cross(other).normalized
    end

    # Returns the distance between this vector and *other*
    def distance(other : Vec)
      (self - other).magnitude
    end

    # Return a new Vec(T) rotated by `theta` in radians
    def rotated(theta)
      cos_theta = Math.cos(theta)
      sin_theta = Math.sin(theta)

      Vec[
        x * cos_theta - y * sin_theta,
        x * sin_theta + y * cos_theta,
      ]
    end

    def round(n = 0)
      Vec[x.round(n), y.round(n)]
    end

    {% for method, type in {
                             to_i: Int32, to_u: UInt32, to_f: Float64,
                             to_i8: Int8, to_i16: Int16, to_i32: Int32, to_i64: Int64, to_i128: Int128,
                             to_u8: UInt8, to_u16: UInt16, to_u32: UInt32, to_u64: UInt64, to_u128: UInt128,
                             to_f32: Float32, to_f64: Float64,
                           } %}
      # Convert the components in this vector to {{ type }}
      def {{ method }}
        Vec({{ type }}).new(@x.{{method}}, @y.{{method}})
      end
    {% end %}
  end
end
