module PF2d
  struct Vec3(T)
    macro [](*args)
      PF2d::Vec3(typeof({{args.splat}})).new({{args.splat}})
    end

    property x : T
    property y : T
    property z : T

    def initialize(@x, @y, @z)
    end

    {% for op in %w[> < >= <= ==] %}
      # Tests if all components of each vector meet the `{{op.id}}` condition
      def {{ op.id }}(other : Vec3)
        @x {{op.id}} other.x && @y {{op.id}} other.y && @z {{op.id}} other.z
      end

      # Tests if all components of this vector meet the `{{op.id}}` condition with the given *n*
      def {{ op.id }}(n : (Int | Float))
        @x {{op.id}} n && @y {{op.id}} n && @z {{op.id}} n
      end
    {% end %}

    {% for op in %w[- abs] %}
      # Calls `{{ op.id }}` on all components of this vector
      def {{op.id}}
        Vec3[@x.{{op.id}}, @y.{{op.id}}, @z.{{op.id}}]
      end
    {% end %}

    {% for op in %w[* / // + - % **] %}
      # Applies `{{op.id}}` to all component of this vector with the corresponding component of *other*
      def {{ op.id }}(other : Vec)
        Vec3[@x {{op.id}} other.x, @y {{op.id}} other.y, @z {{op.id}} other.z]
      end

      # Applies `{{op.id}}` to all component of this vector with *n*
      def {{ op.id }}(n : (Int | Float))
        Vec3[@x {{op.id}} n, @y {{op.id}} n, @z {{op.id}} n]
      end
    {% end %}

    # Add all components together
    def sum
      @x + @y + @z
    end

    # The length or magnitude of the vector calculated by the Pythagorean theorem
    def magnitude
      Math.sqrt(@x ** 2 + @y ** 2 + @z ** 2)
    end

    # Returns a new normalized unit `Vec3`
    def normalized
      m = magnitude
      return self if m == 0
      i = (1.0 / m)
      Vec3[@x * i, @y * i, @z * i]
    end

    # Returns the dot product of this vector and *other*
    def dot(other : Vec3)
      @x * other.x + @y * other.y + @z * other.z
    end

    # Calculates the cross product of this vector and *other*
    def cross(other : Vec3)
      Vec3[
        @y * other.z - @z * other.y,
        @z * other.x - @x * other.z,
        @x * other.y - @y * other.x,
      ]
    end

    # Returns normalized value at a normal to the current vector
    def normal(other : Vec3)
      cross(other).normalized
    end

    # Returns the distance between this vector and *other*
    def distance(other : Vec3)
      (self - other).magnitude
    end

    {% for method, type in {
                             to_i: Int32, to_u: UInt32, to_f: Float64,
                             to_i8: Int8, to_i16: Int16, to_i32: Int32, to_i64: Int64, to_i128: Int128,
                             to_u8: UInt8, to_u16: UInt16, to_u32: UInt32, to_u64: UInt64, to_u128: UInt128,
                             to_f32: Float32, to_f64: Float64,
                           } %}
      # Convert the components in this vector to {{ type }}
      def {{ method }}
        Vec3({{ type }}).new(@x.{{method}}, @y.{{method}}, @z.{{method}})
      end
    {% end %}
  end
end
