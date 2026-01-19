module PF2d
  # Represents a polygon with 4 points,
  # in a clockwise winding starting from the upper-left
  struct Quad(T)
    macro [](*args)
      PF2d::Quad.new({{args.splat}})
    end

    property p1 : Vec2(T), p2 : Vec2(T), p3 : Vec2(T), p4 : Vec2(T)

    def initialize(@p1, @p2, @p3, @p4)
    end

    def points
      {p1, p2, p3, p4}
    end

    def point_pointers
      {pointerof(p1), pointerof(p2), pointerof(p3), pointerof(p4)}
    end

    def line_1
      Line[p1, p2]
    end

    def line_2
      Line[p2, p3]
    end

    def line_3
      Line[p3, p4]
    end

    def line_4
      Line[p4, p1]
    end

    def lines
      {line_1, line_2, line_3, line_4}
    end

    def bounding_box
      min_x = {p1,p2,p3,p4}.map(&.x).min
      min_y = {p1,p2,p3,p4}.map(&.y).min
      max_x = {p1,p2,p3,p4}.map(&.x).max
      max_y = {p1,p2,p3,p4}.map(&.y).max

      tl = Vec[min_x, min_y]
      sz = Vec[max_x, max_y] - tl

      Rect[tl, sz]
    end

    def tris(cast = T)
      {
        Tri[@p1.to(cast), @p2.to(cast), @p4.to(cast)],
        Tri[@p2.to(cast), @p3.to(cast), @p4.to(cast)],
      }
    end

    # TODO
    # def map_points(other : Quad)
    # end
  end
end
