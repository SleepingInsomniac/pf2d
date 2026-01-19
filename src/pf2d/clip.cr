module PF2d
  class Clip(T)
    include Canvas(T)

    getter rect : Rect(Int32)
    getter source : Canvas(T)

    delegate :width, :height, :size, to: rect

    def initialize(rect : Rect, @source)
      @rect = rect.to_i
    end

    def get_point?(x, y) : T?
      return nil unless in_bounds?(x, y)
      p = Vec[x, y] + rect.top_left
      source.get_point?(p)
    end

    def draw_point(x, y, value)
      p = Vec[x, y] + rect.top_left
      source.draw_point(p, value) if in_bounds?(x, y)
    end
  end
end
