module PF2d
  # A `Grid` is a generic drawable and viewable 2d array
  alias Grid = GridSlice

  # All points laid out contiguously
  abstract class LinearGrid(T)
    include Canvas(T)

    abstract def width
    abstract def height
    abstract def data

    def i(x, y)
      y * width + x
    end

    def draw_point(x, y, value)
      return nil unless in_bounds?(x, y)
      data[i(x, y)] = value
    end

    def get_point?(x, y) : T?
      return nil unless in_bounds?(x, y)
      data[i(x, y)]
    end

    def row(y)
      data[(y * width)..(y * width + (width - 1))]
    end
  end

  {% for t in [Array, Slice] %}
    class Grid{{t}} < LinearGrid(T)
      include Canvas(T)

      getter width : Int32, height : Int32
      property data : {{t}}

      def initialize(@data, @width, @height)
      end

      def initialize(@width, @height, & : Vec2(Int32), Vec2(Int32) -> T)
        s = size
        @data = {{t}}.new(@width * @height) do |i|
          y, x = i.divmod(@width)
          yield Vec[x, y], s
        end
      end
    end
  {% end %}
end
