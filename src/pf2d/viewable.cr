module PF2d::Viewable(T)
  # To be implemented by the including class
  abstract def get_point?(x : Number, y : Number) : T?

  def get_point?(point : PF2d::Vec2) : T?
    get_point?(point.x, point.y)
  end

  def get_point(x : Number, y : Number) : T
    point = get_point?(x, y)
    raise IndexError.new("out of bounds") if point.nil?
    point
  end

  def get_point(point : PF2d::Vec2) : T
    get_point(point.x, point.y)
  end

  def [](x, y)
    get_point(x, y)
  end

  def [](point : PF2d::Vec2)
    get_point(point)
  end

  def []?(x, y)
    get_point?(x, y)
  end

  def []?(point : PF2d::Vec2)
    get_point?(point)
  end

  def each(rect : PF2d::Rect, & : T, Vec2(Int32) ->)
    rect.top_left.y.upto(rect.top_left.y + rect.size.y - 1).each do |y|
      rect.top_left.x.upto(rect.top_left.x + rect.size.x - 1).each do |x|
        point = Vec[x, y]
        yield get_point(point), point
      end
    end
  end
end
