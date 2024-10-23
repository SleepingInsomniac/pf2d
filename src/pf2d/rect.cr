module PF2d
  struct Rect(T)
    property top_left : Vec2(T)
    property size : Vec2(T)

    def initialize(@top_left, @size)
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
  end
end
