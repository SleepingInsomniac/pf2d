module PF2d::Viewable(T)
  abstract def size : PF2d::Vec2

  def width
    size.x
  end

  def height
    size.y
  end

  # To be implemented by the including class
  abstract def get_point(x : Number, y : Number)

  def get_point(point : PF2d::Vec2)
    get_point(point.x, point.y)
  end
end
