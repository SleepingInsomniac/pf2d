require "./drawable"
require "./viewable"

module PF2d
  module Canvas(T)
    include Drawable(T)
    include Viewable(T)

    macro [](*args)
      {{@type}}.new({{ args.splat }})
    end

    abstract def width
    abstract def height

    def size
      Vec[width, height]
    end

    def in_bounds?(x, y)
      x >= 0 && y >= 0 && x < width && y < height
    end

    def in_bounds?(point)
      in_bounds?(point.x, point.y)
    end

    abstract def blend(src, dst) : T

    def draw(canvas : Canvas(T), src_rect : Rect(Number), dst_rect : Rect(Number))
      src_rect.map_points(dst_rect) do |src, dst|
        if source_color = canvas[src]?
          if dest_color = self[dst]?
            self[dst] = blend(dest_color, source_color)
          else
            self[dst] = source_color
          end
        end
      end
    end

    def draw(canvas  : Canvas(T), pos : Vec = Vec[0, 0])
      canvas.each_point do |src|
        dst = pos + src
        if source_color = canvas[src]?
          if dest_color = self[dst]?
            self[dst] = blend(dest_color, source_color)
          else
            self[dst] = source_color
          end
        end
      end
    end

    def draw(canvas  : Canvas(T), src_rect : Rect(Number), pos : Vec = Vec[0, 0])
      draw(Clip.new(src_rect, canvas), pos)
    end
  end
end
