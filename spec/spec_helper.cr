require "colorize"
require "spec"
require "../src/pf2d"

macro display
  {% if flag?(:visual) %}
    {{ yield }}
  {% end %}
end

struct RGBA
  macro [](*args)
    RGBA.new({{args.splat}})
  end

  property r : UInt8 = 0u8
  property g : UInt8 = 0u8
  property b : UInt8 = 0u8
  property a : UInt8 = 0u8

  def initialize(@r = 0u8, @g = 0u8, @b = 0u8, @a = 0u8)
  end

  def *(n : Number)
    self
  end

  # Alpha blend self over dest
  def blend(dest : RGBA) : RGBA
    a_s = @a

    return dest if a_s == 0u8

    a_d = dest.a
    inv_a_s = 255u16 - a_s.to_u16
    out_a = a_s.to_u16 + (a_d.to_u16 * inv_a_s) // 255u16

    return RGBA.new(0u8, 0u8, 0u8, 0u8) if out_a == 0

    r = (@r.to_u16 * a_s.to_u16 + dest.r.to_u16 * a_d.to_u16 * inv_a_s // 255u16)
    g = (@g.to_u16 * a_s.to_u16 + dest.g.to_u16 * a_d.to_u16 * inv_a_s // 255u16)
    b = (@b.to_u16 * a_s.to_u16 + dest.b.to_u16 * a_d.to_u16 * inv_a_s // 255u16)

    RGBA.new(r.to_u8, g.to_u8, b.to_u8, out_a.to_u8)
  end
end

WHITE = RGBA.new(255, 255, 255, 255)

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
