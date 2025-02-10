module PF2d
  struct Rect(T)
    property top_left : Vec2(T)
    property size : Vec2(T)

    def initialize(@top_left, @size)
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
  end
end
