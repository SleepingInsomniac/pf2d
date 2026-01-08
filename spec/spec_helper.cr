require "spec"
require "../src/pf2d"

module PF2d
  class TestCanvas < Grid(Bool)
    def to_s(io : IO)
      io << "┌" << "─" * width * 2 << "┐\n"
      0.upto(height - 1) do |y|
        io << "│"
        0.upto(width - 1) do |x|
          io << (get_point(x, y) ? "██" : "  ")
        end
        io << "│\n"
      end
      io << "└" << "─" * width * 2 << "┘"
    end
  end
end
