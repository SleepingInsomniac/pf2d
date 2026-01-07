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
end
