module PF2d
  # A Poly is a clockwise winding of *N* points Vec(T)
  struct Poly(T)
    property points : Enumerable(Vec2(T))

    def initialize(@points)
    end
  end
end
