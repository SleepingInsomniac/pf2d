module PF2d
  alias Grid = GridSlice

  {% for t in [Array, Slice] %}
  # A `Grid` is a generic drawable and viewable 2d array of any type
  class Grid{{t}}
    include Canvas(T)

    getter width : Int32, height : Int32
    property data : {{t}}

    def initialize(@data, @width, @height)
    end

    def initialize(@width, @height)
      @data = {{t}}.new(@width * @height) do |i|
        y, x = i.divmod(@width)
        yield(Vec[x, y], size)
      end
    end

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
  {% end %}
end
