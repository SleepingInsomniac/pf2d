module PF2d
  module Canvas(T)
    include Drawable(T)
    include Viewable(T)
    include Enumerable(Tuple(Vec2(Int32), T))

    macro [](*args)
      {{@type}}.new({{ args.splat }})
    end

    abstract def width
    abstract def height

    def size
      Vec[width, height]
    end

    def rect
      Rect[Vec[0, 0], size.to_i32]
    end

    def quad
      Quad[Vec[0, 0], Vec[size.x.to_i32 - 1, 0], size.to_i32 - 1, Vec[0, size.y.to_i32 - 1]]
    end

    def in_bounds?(x, y)
      x >= 0 && y >= 0 && x < width && y < height
    end

    def in_bounds?(point)
      in_bounds?(point.x, point.y)
    end

    def each_row(&)
      0.upto(height - 1) do |y|
        yield Array.new(width) { |x| get_point(x, y) }
      end
    end

    def each_point(&)
      0.upto(height - 1) do |y|
        0.upto(width - 1) do |x|
          yield Vec[x, y]
        end
      end
    end

    def each(&)
      0.upto(height - 1) do |y|
        0.upto(height - 1) do |x|
          yield({Vec[x, y].to_i32, self[x, y]})
        end
      end
    end

    # Copy *canvas* to self, yielding a block with *src* value and *dst* value that will
    # determine how the values are blended
    # - src_rect is scaled to dst_rect
    def draw(canvas : Canvas(T), src_rect : Rect(Number), dst_rect : Rect(Number), &)
      scale = src_rect.size / dst_rect.size
      dst_clip = (dst_rect.intersection?(self.rect) || dst_rect).to_f64
      src_clip = src_rect.to_f64

      if dst_rect.top_left.x < 0
        src_clip.top_left.x = -(dst_rect.top_left.x * scale.x)
      end

      if dst_rect.top_left.y < 0
        src_clip.top_left.y = -(dst_rect.top_left.y * scale.y)
      end

      src_clip.map_points(dst_clip, scale) do |src, dst|
        if source_color = canvas[src]?
          if dest_color = self[dst]?
            self[dst] = yield(source_color, dest_color)
          else
            self[dst] = source_color
          end
        end
      end
    end

    def draw(canvas  : Canvas(T), pos : Vec = Vec[0, 0], src_rect : Rect(Number)? = nil, &)
      src_rect ||= canvas.rect
      src_rect.each do |src|
        dst = pos + src
        if source_color = canvas[src]?
          if dest_color = self[dst]?
            self[dst] = yield(source_color, dest_color)
          else
            self[dst] = source_color
          end
        end
      end
    end

    def draw(canvas : Canvas(T), pos : Vec = Vec[0, 0])
      draw(canvas, pos) { |src, dst| src }
    end

    def draw(canvas : Canvas(T), pos : Vec = Vec[0, 0], src_rect : Rect(Number)? = nil)
      # Just return source value if no block given (this will overwrite the entire rect)
      draw(canvas, pos, src_rect) { |src, dst| src }
    end

    def clip(rect : Rect)
      Clip.new(rect, self)
    end
  end
end
