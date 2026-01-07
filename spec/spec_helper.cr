require "spec"
require "../src/pf2d"

module PF2d
  class TestCanvas
    include Canvas(Bool)

    getter width : Int32, height : Int32

    def initialize(@width : Int32, @height : Int32)
      @buffer = Bytes.new(@width // sizeof(UInt8) * @height)
    end

    def index(x, y)
      (y * @width + x).divmod(sizeof(UInt8))
    end

    def blend(src, dst) : Bool
      src || dst
    end

    def draw_point(x, y, value)
      byte, bit = index(x, y)
      if value
        @buffer[byte] |= 1 << bit
      else
        @buffer[byte] &= ~(1 << bit)
      end
    end

    def get_point?(x, y) : Bool?
      return nil if x < 0 || y < 0 || x >= @width || y >= @height
      byte, bit = index(x, y)
      (@buffer[byte] & (1 << bit)) != 0
    end

    def to_s(io : IO)
      io << "┌" << "─" * width * 2 << "┐\n"
      0.upto(height - 1) do |y|
        io << "│"
        0.upto(width - 1) do |x|
          io << (get_point(x, y) ? "██" : "  ")
        end
        io << "│\n"
      end
      io << "└" << "─" * width * 2 << "┘\n"
      io
    end
  end
end
