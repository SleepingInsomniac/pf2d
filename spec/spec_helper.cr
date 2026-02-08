require "spec"
require "colorize"
require "./color"
require "../src/pf2d"

macro visual
  {% if flag?(:visual) %}
    {{ yield }}
  {% end %}
end

WHITE = RGBA[0xFFFFFFFF]

class TestGrid < PF2d::Grid(RGBA)
  def initialize(@width, @height)
    @data = Slice(RGBA).new(@width * @height) { RGBA.new }
  end

  def to_s(io : IO)
    io << "┌" << "─" * width * 2 << "┐\n"
    0.upto(height - 1) do |y|
      io << "│"
      0.upto(width - 1) do |x|
        c = get_point(x, y)
        io << (c.a == 0 ? "  " : "██".colorize(c.r, c.g, c.b))
      end
      io << "│\n"
    end
    io << "└" << "─" * width * 2 << "┘"
  end
end

class String
  def decolorize
    gsub(/\e\[[0-9;]*[A-Za-z]/, "")
  end
end

PF2d::Matrix.define(2, 2)
PF2d::Matrix.define(3, 3)
PF2d::Matrix.define(4, 4)
PF2d::Mat2x2.define_mul(2)
PF2d::Mat4x4.define_mul(4)
