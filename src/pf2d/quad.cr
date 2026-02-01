module PF2d
  # Represents a polygon with 4 points,
  # in a clockwise winding starting from the upper-left
  struct Quad(T) < Points(4)
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

    def tris
      {
        Tri[@p1, @p2, @p4],
        Tri[@p2, @p3, @p4],
      }
    end

    # TODO
    # def map_points(other : Quad)
    # end
  end
end
