module PF2d
  # A `Grid` is a generic drawable and viewable 2d array of any type
  class Grid(T)
    include Canvas(T)

    getter width : Int32, height : Int32
    @grid : Array(T)

    def initialize(@width, @height)
      @grid = Array(T).new(@width * @height) { yield }
    end

    def i(x, y)
      y * @width + x
    end

    def draw_point(x, y, value)
      return nil unless in_bounds?(x, y)
      @grid[i(x, y)] = value
    end

    def get_point?(x, y) : T?
      return nil unless in_bounds?(x, y)
      @grid[i(x, y)]
    end
  end
end
