module PF2d
  struct Circle(T)
    property center : Vec2(T)
    property radius : T

    def initialize(@center : Vec2(T), @radius : T)
    end
  end
end
