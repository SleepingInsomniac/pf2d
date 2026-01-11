require "./vec"
require "./line"

module PF2d
  struct Rect(T)
    macro [](*args)
      PF2d::Rect.new({{args.splat}})
    end

    include Enumerable(Vec2(T))

    property top_left : Vec2(T)
    property size : Vec2(T)

    def initialize(x : T, y : T, width : T, height : T)
      @top_left = Vec[x, y]
      @size = Vec[width, height]
    end

    def initialize(@top_left, @size)
    end

    def width
      size.x
    end

    def height
      size.y
    end

    def left_edge
      Line[top_left, bottom_left]
    end

    def right_edge
      Line[top_right, bottom_right]
    end

    def top_edge
      Line[top_left, top_right]
    end

    def bottom_edge
      Line[bottom_left, bottom_right]
    end

    def top
      top_left.y
    end

    def bottom
      top_left.y + size.y
    end

    def top_right
      top_left + Vec[size.x, T.new(0)]
    end

    def bottom_right
      top_left + size
    end

    def bottom_left
      top_left + Vec[T.new(0), size.y]
    end

    def covers?(point : Vec)
      top_left <= point && point <= bottom_right
    end

    def covers?(other : Rect)
      top_left <= other.top_left && size >= other.size
    end

    def merge(other : Rect)
      new_top_left = top_left
      new_bottom_right = bottom_right
      new_top_left.x = other.top_left.x if other.top_left.x < top_left.x
      new_top_left.y = other.top_left.y if other.top_left.y < top_left.y
      new_bottom_right.x = other.bottom_right.x if other.bottom_right.x > bottom_right.x
      new_bottom_right.y = other.bottom_right.y if other.bottom_right.y > bottom_right.y
      Rect.new(new_top_left, new_bottom_right - new_top_left)
    end

    def map_points(dest : Rect(Number))
      scale = size / dest.size

      0.upto(dest.size.y - 1) do |y|
        sy = ((y * scale.y) + top_left.y).to_i32
        dy = y + dest.top_left.y

        0.upto(dest.size.x - 1) do |x|
          sx = ((x * scale.x) + top_left.x).to_i32
          dx = x + dest.top_left.x

          yield Vec[sx, sy], Vec[dx, dy]
        end
      end
    end

    def each(&)
      0.upto(size.y - 1) do |y|
        0.upto(size.x - 1) do |x|
          yield Vec[x, y] + top_left
        end
      end
    end

    {% for method, type in {
      to_i: Int32, to_u: UInt32, to_f: Float64,
      to_i8: Int8, to_i16: Int16, to_i32: Int32, to_i64: Int64, to_i128: Int128,
      to_u8: UInt8, to_u16: UInt16, to_u32: UInt32, to_u64: UInt64, to_u128: UInt128,
      to_f32: Float32, to_f64: Float64,
    } %}
      # Return a new Rect as Rect({{ type }})
      def {{ method }}
        Rect[top_left.{{method}}, size.{{method}}]
      end
    {% end %}
  end
end
