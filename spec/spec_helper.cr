require "spec"
require "../src/pf2d"

macro display
  {% if flag?(:visual) %}
    {{ yield }}
  {% end %}
end

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

PF2d::Matrix.define(2, 2)
PF2d::Matrix.define(3, 3)
PF2d::Matrix.define(4, 4)
PF2d::Mat2x2.define_mul(2)
PF2d::Mat4x4.define_mul(4)
