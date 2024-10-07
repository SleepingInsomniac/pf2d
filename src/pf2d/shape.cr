module PF2d
  # A shape is a clockwise winding of *N* points Vec(T)
  struct Shape(T)
    property points : Enumerable(Vec2(T))

    def initialize(@points)
    end
  end
end
