module PF2d
  # A Poly is a clockwise winding of *N* points Vec(T)
  struct Poly(T)
    property points : Enumerable(T)

    def initialize(@points)
    end
  end
end
