require "../../spec_helper"

struct Rgb(T)
  property r : T = T.new(0)
  property g : T = T.new(0)
  property b : T = T.new(0)

  def initialize(@r, @g, @b)
  end

  def to_s(io)
    io << "██".colorize(@r, @g, @b)
  end

  def *(n : Number)
    self
  end

  def black?
    @r == 0 && @g == 0 && @b == 0
  end
end

def stringify(canvas)
  String.build do |io|
    io << "┌" << "─" * canvas.width * 2 << "┐" << "\n"
    canvas.each_row do |row|
      io << "│"
      row.map { |c| io << (c.black? ? "  " : "██") }
      io << "│\n"
    end
    io << "└" << "─" * canvas.width * 2 << "┘" << "\n"
  end
end

describe PF2d::Drawable do
  describe "#paint_triangle" do
    it "renders a flat top triangle" do
      canvas = PF2d::Grid(Rgb(UInt8)).new(10, 10) { Rgb(UInt8).new(0, 0, 0) }
      depth_buffer = PF2d::Grid(Float64).new(10, 10) { 0.0 }

      p1 = PF2d::Vec[0.0, 0.0, 0.0]
      p2 = PF2d::Vec[8.0, 0.0, 0.0]
      p3 = PF2d::Vec[4.0, 9.0, 0.0]

      t1 = PF2d::Vec[0.0, 0.0, 1.0]
      t2 = PF2d::Vec[1.0, 0.0, 1.0]
      t3 = PF2d::Vec[0.0, 1.0, 1.0]

      canvas.paint_triangle(p1, p2, p3, t1, t2, t3, nil, depth_buffer, Rgb(UInt8).new(0, 255, 255))

      display do
        puts
        puts stringify(canvas)
      end

      stringify(canvas).chomp.should eq(<<-GRID)
      ┌────────────────────┐
      │██████████████████  │
      │██████████████████  │
      │  ██████████████    │
      │  ██████████████    │
      │    ██████████      │
      │    ██████████      │
      │      ██████        │
      │      ██████        │
      │        ██          │
      │        ██          │
      └────────────────────┘
      GRID
    end

    it "renders a flat bottom triangle" do
      canvas = PF2d::Grid(Rgb(UInt8)).new(10, 10) { Rgb(UInt8).new(0, 0, 0) }
      depth_buffer = PF2d::Grid(Float64).new(10, 10) { 0.0 }

      p1 = PF2d::Vec[0.0, 9.0, 0.0]
      p2 = PF2d::Vec[4.0, 0.0, 0.0]
      p3 = PF2d::Vec[8.0, 9.0, 0.0]

      t1 = PF2d::Vec[0.0, 0.0, 1.0]
      t2 = PF2d::Vec[1.0, 0.0, 1.0]
      t3 = PF2d::Vec[0.0, 1.0, 1.0]

      canvas.paint_triangle(p1, p2, p3, t1, t2, t3, nil, depth_buffer, Rgb(UInt8).new(0, 255, 255))

      display do
        puts
        puts stringify(canvas)
      end

      stringify(canvas).chomp.should eq(<<-GRID)
      ┌────────────────────┐
      │        ██          │
      │        ██          │
      │      ██████        │
      │      ██████        │
      │    ██████████      │
      │    ██████████      │
      │  ██████████████    │
      │  ██████████████    │
      │██████████████████  │
      │██████████████████  │
      └────────────────────┘
      GRID
    end

    it "renders a right pointing triangle" do
      canvas = PF2d::Grid(Rgb(UInt8)).new(10, 10) { Rgb(UInt8).new(0, 0, 0) }
      depth_buffer = PF2d::Grid(Float64).new(10, 10) { 0.0 }

      p1 = PF2d::Vec[2.0, 0.0, 0.0]
      p2 = PF2d::Vec[9.0, 5.0, 0.0]
      p3 = PF2d::Vec[0.0, 9.0, 0.0]

      t1 = PF2d::Vec[0.0, 0.0, 1.0]
      t2 = PF2d::Vec[1.0, 0.0, 1.0]
      t3 = PF2d::Vec[0.0, 1.0, 1.0]

      canvas.paint_triangle(p1, p2, p3, t1, t2, t3, nil, depth_buffer, Rgb(UInt8).new(0, 255, 255))

      display do
        puts
        puts stringify(canvas)
      end

      stringify(canvas).chomp.should eq(<<-GRID)
      ┌────────────────────┐
      │    ██              │
      │    ████            │
      │    ████████        │
      │  ████████████      │
      │  ████████████████  │
      │  ██████████████████│
      │  ██████████████    │
      │████████████        │
      │██████              │
      │██                  │
      └────────────────────┘
      GRID
    end
  end
end
