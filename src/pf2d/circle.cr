module PF2d
  struct Circle(T)
    macro [](*args)
      PF2d::Circle(typeof({{args.splat}})).new({{args.splat}})
    end

    property center : Vec2(T)
    property radius : T

    def initialize(cx, cy, @radius : T)
      @center = Vec[cx, cy]
    end

    def initialize(@center : Vec2(T), @radius : T)
    end

    def area
      Math::PI * radius ** 2
    end

    def contains?(point : Vec2)
      (point - center) ** 2 <= radius ** 2
    end
  end
end
