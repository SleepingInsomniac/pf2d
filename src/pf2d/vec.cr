require "./matrix"

module PF2d
  abstract struct Vec
    # Creates a new `Vec` with the given *args*
    #
    # ```
    # PF2d::Vec[1, 2] # => PF2d::Vec2(Int32)(@x=1, @y=2)
    # ```
    macro [](*args)
      PF2d::Vec{{args.size}}(typeof({{args.splat}})).new({{args.splat}})
    end

    def self.from_angle(degrees : Number)
      Vec.from_radians(degrees * Math::PI / 180.0)
    end

    def self.from_radians(radians : Float64)
      Vec[Math.cos(radians), Math.sin(radians)]
    end
  end

  {% for i in 2..4 %}
    {% vars = %w[x y z w] %}
    struct Vec{{i}}(T) < Vec
      include Comparable(Vec{{i}})

      {% for arg in 0...i %}
        property {{vars[arg].id}} : T
      {% end %}

      def initialize({% for arg in 0...i %} @{{vars[arg].id}} : T, {% end %})
      end

      # Returns the size of this Vec
      # ```
      # PF2d::Vec{{i}}.new(...).size => {{i}}
      # ```
      def size
        {{ i.id }}
      end

      def map
        Vec[{% for arg in 0...i %}
          yield {{vars[arg].id}},
        {% end %}]
      end

      # Converts this Vec into a `StaticArray(T, {{i}})`
      def to_a
        StaticArray[{% for arg in 0...i %} @{{vars[arg].id}}, {% end %}]
      end

      {% for op in %w[> < >= <=] %}
      #   # Tests if all components of each Vec meet the `{{op.id}}` condition
      #   def {{ op.id }}(other : Vec{{i}})
      #     {% for arg in 0...i %}
      #       return false unless @{{vars[arg].id}} {{op.id}} other.{{vars[arg].id}}
      #     {% end %}
      #     true
      #   end

        # Tests if all components of this Vec meet the `{{op.id}}` condition with the given *n*
        def {{ op.id }}(n : Number)
          {% for arg in 0...i %}
            return false unless @{{vars[arg].id}} {{op.id}} n
          {% end %}
          true
        end
      {% end %}

      # Compares each component against other.
      def <=>(other : Vec{{i}})
        {% for arg in 0...i %}
          return -1 if @{{vars[i - arg - 1].id}} < other.{{vars[i - arg - 1].id}}
          return 1 if @{{vars[i - arg - 1].id}} > other.{{vars[i - arg - 1].id}}
        {% end %}
        0
      end

      {% for op in %w[- abs] %}
        # Calls `{{ op.id }}` on all components of this Vec
        def {{op.id}}
          Vec{{i}}(T).new({% for arg in 0...i %} @{{vars[arg].id}}.{{op.id}}, {% end %})
        end
      {% end %}

      {% for op in %w[* / // + - % **] %}
        # Applies `{{op.id}}` to all component of this Vec with the corresponding component of *other*
        def {{ op.id }}(other : Vec{{i}})
          Vec[{% for arg in 0...i %} @{{vars[arg].id}} {{op.id}} other.{{vars[arg].id}}, {% end %}]
        end

        # Applies `{{op.id}}` to all component of this Vec with *n*
        def {{ op.id }}(n : Number)
          Vec[{% for arg in 0...i %} @{{vars[arg].id}} {{op.id}} n, {% end %}]
        end

        def {{ op.id }}(other : Indexable)
          Vec[{% for arg in 0...i %} @{{vars[arg].id}} {{op.id}} other[{{arg}}], {% end %}]
        end
      {% end %}

      # Add all components together
      def sum
        {% for arg in 0...i %}
          @{{vars[arg].id}} {% if arg != i - 1 %} + {% end %}
        {% end %}
      end

      # The length or magnitude of the Vec calculated by the Pythagorean theorem
      def magnitude
        Math.sqrt({% for arg in 0...i %} @{{vars[arg].id}} ** 2 {% if arg != i - 1 %} + {% end %}{% end %})
      end

      # Returns a new normalized unit `Vec{{i}}`
      def normalized
        m = magnitude
        return self if m == 0
        i = (1.0 / m)
        Vec[{% for arg in 0...i %} @{{vars[arg].id}} * i, {% end %}]
      end

      # Returns the dot product of this Vec and *other*
      def dot(other : Vec{{i}})
        {% for arg in 0...i %} @{{vars[arg].id}} * other.{{vars[arg].id}} {% if arg != i - 1 %} + {% end %}{% end %}
      end

      def det(other : Vec2)
        x * other.y - y * other.x
      end

      # Calculates the cross product of this Vec and *other*
      def cross(other : Vec{{i}})
        {% if i == 2 %}
          Vec[
            x * other.y - y * other.x,
            y * other.x - x * other.y,
          ]
        {% elsif i == 3 %}
          Vec[
            y * other.z - z * other.y,
            z * other.x - x * other.z,
            x * other.y - y * other.x,
          ]
        {% elsif i == 4 %}
          Vec[
            y * other.z - z * other.y,
            z * other.x - x * other.z,
            x * other.y - y * other.x,
            T.new(0),
          ]
        {% end %}
      end

      # Returns normalized value at a normal to the current Vec
      def normal(other : Vec{{i}})
        cross(other).normalized
      end

      # Returns the distance between this Vec and *other*
      def distance(other : Vec{{i}})
        (self - other).magnitude
      end

      def rotate(angle : Float)
        Vec[
          (x * Math.cos(angle) - y * Math.sin(angle)),
          (x * Math.sin(angle) + y * Math.cos(angle))
        ]
      end

      # Multiply this Vec by a *matrix*
      #
      # ```
      # v = PF2d::Vec[1, 2, 3]
      # m = PF::Matrix[
      #   1, 0, 0,
      #   0, 2, 0,
      #   0, 0, 1,
      # ]
      # # => PF2d::Vec3(Int32)(@x=1, @y=4, @z=3)
      # ```
      def *(matrix : Matrix)
        PF2d::Vec[{% for row in 0...i %}
          {% for col in 0...i %} @{{ vars[col].id }} * matrix[{{col}}, {{row}}] {% if col != i - 1 %} + {% end %}{% end %},
        {% end %}]
      end

      {% for method, type in {
                               to_i: Int32, to_u: UInt32, to_f: Float64,
                               to_i8: Int8, to_i16: Int16, to_i32: Int32, to_i64: Int64, to_i128: Int128,
                               to_u8: UInt8, to_u16: UInt16, to_u32: UInt32, to_u64: UInt64, to_u128: UInt128,
                               to_f32: Float32, to_f64: Float64,
                             } %}
        # Convert the components in this Vec to {{ type }}
        def {{ method }}
          Vec{{i}}({{ type }}).new({% for arg in 0...i %} @{{vars[arg].id}}.{{method}}, {% end %})
        end
      {% end %}

      def round32(precision = 0)
        Vec{{i}}(Float32).new({% for arg in 0...i %} @{{vars[arg].id}}.to_f32.round(precision), {% end %})
      end

      def round(precision = 0)
        Vec{{i}}(Float64).new({% for arg in 0...i %} @{{vars[arg].id}}.to_f64.round(precision), {% end %})
      end

      def to(type)
        Vec[{% for arg in 0...i %} type.new(@{{vars[arg].id}}), {% end %}]
      end

      def to_vec2
        Vec[@x, @y]
      end

      def to_tuple
        Tuple.new({% for arg in 0...i %} @{{vars[arg].id}}, {% end %})
      end
    end
  {% end %}
end
