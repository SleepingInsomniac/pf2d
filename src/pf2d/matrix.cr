module PF2d
  abstract struct Matrix(T, W, H)
    macro define(width, height)
      {% unless PF2d.has_constant?("Mat#{width}x#{height}") %}
        struct ::PF2d::Mat{{width}}x{{height}}(T) < ::PF2d::Matrix(T, {{width}}, {{height}})
          W = {{width}}
          H = {{height}}
          S = {{width * height}}

          getter data : StaticArray(T, S)

          def initialize
            @data = StaticArray(T, S).new(0)
          end

          def initialize(@data)
          end
        end
      {% end %}
    end

    macro [](*args)
      PF2d::Mat{{W}}x{{H}}.new(StaticArray[{{args.splat}}])
    end

    include Indexable::Mutable(T)

    delegate :fill, :unsafe_fetch, :unsafe_put, :size, to: @data

    def ==(other : self)
      @data == other.data
    end

    def width
      W
    end

    def height
      H
    end

    @[AlwaysInline]
    def [](row : Int, col : Int)
      @data[row * {{ W }} + col]
    end

    @[AlwaysInline]
    def []=(row : Int, col : Int, value : T)
      @data[row * {{ H }} + col] = value
    end

    def to_s(io)
      max_len = max.to_s.size
      io << {{@type.stringify}} << "[\n"
      {% for r in 0...H %}
        io << "  "
        {% for c in 0...W %}
          io << @data[{{ r * W + c }}].to_s.rjust(max_len) {% if c < W - 1 %} << ", " {% end %}
        {% end %}
        {% if r < H - 1 %} io << "\n" {% end %}
      {% end %}
      io << "\n]"
    end

    macro define_mul(w)
      struct ::PF2d::Mat{{W}}x{{H}}(T)
        def *(other : ::PF2d::Mat{{w}}x{{W}})
          ::PF2d::Mat{{w}}x{{H}}.new(StaticArray[
            {% for r in 0...H %}
              {% for c in 0...w %}
                (
                  {% for n in 0...W %}
                    @data[{{r * W + n}}] * other.data[{{n * w + c}}] {% if n < W - 1 %}+{% end %}
                  {% end %}
                ),
              {% end %}
            {% end %}
          ])
        end
      end
    end
  end
end
