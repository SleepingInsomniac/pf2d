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
      @data[row * W + col]
    end

    @[AlwaysInline]
    def []=(row : Int, col : Int, value : T)
      @data[row * W + col] = value
    end

    # Gaussian elimination
    def solve?
      unknowns = W - 1
      rhs = W - 1

      0.upto(unknowns - 1) do |k|
        pivot_row = k
        max_val = self[k, k].abs

        (k + 1).upto(H - 1) do |i|
          v = self[i, k].abs
          if v > max_val
            max_val = v
            pivot_row = i
          end
        end

        return nil if max_val.abs < 1e-9

        swap_rows(k, pivot_row) if pivot_row != k

        # Eliminate rows below
        (k + 1).upto(H - 1) do |i|
          factor = self[i, k] / self[k, k]

          (k + 1).upto(W - 1) do |j|
            self[i, j] = self[i, j] - factor * self[k, j]
          end

          self[i, k] = 0.0
        end
      end

      rhs = W - 1

      result = StaticArray(Float64, H).new(0.0)

      (H - 1).downto(0) do |i|
        sum = 0.0
        (i + 1).upto(H - 1) do |j|
          sum += self[i, j] * result[j]
        end

        result[i] = (self[i, rhs] - sum) / self[i, i]
      end

      result
    end

    def swap_rows(r1, r2)
      (0...W).each do |col|
        self[r1, col], self[r2, col] = self[r2, col], self[r1, col]
      end
    end

    def swap_cols(c1, c2)
      (0...H).each do |row|
        self[row, c1], self[row, c2] = self[row, c2], self[row, c1]
      end
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
