require "../../spec_helper"

describe PF2d::Drawable do
  describe "#paint_triangle" do
    texture = TestGrid.new(10, 10)
    texture.each do |(p, _c)|
      shade = (texture.height - p.y) / texture.height
      texture[p] = ((p.x + p.y) % 2 == 0 ? RGBA[0x880088FF] : RGBA.new(0, (255 * shade).to_u8, 0, 255))
    end

    t1 = PF2d::Vec[0.0, 0.0, 1.0]
    t2 = PF2d::Vec[1.0, 0.0, 1.0]
    t3 = PF2d::Vec[0.0, 1.0, 1.0]
    tint = WHITE

    it "renders a flat top triangle" do
      canvas = TestGrid.new(10, 10)
      depth_buffer = PF2d::Grid(Float64).new(10, 10) { 0.0 }

      p1 = PF2d::Vec[0.0, 0.0, 0.0]
      p2 = PF2d::Vec[8.0, 0.0, 0.0]
      p3 = PF2d::Vec[4.0, 9.0, 0.0]

      canvas.paint_triangle(p1, p2, p3, t1, t2, t3, texture, depth_buffer, tint)

      visual do
        puts
        puts canvas.to_s
      end

      canvas.to_s.decolorize.should eq(<<-GRID)
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
      canvas = TestGrid.new(10, 10)
      depth_buffer = PF2d::Grid(Float64).new(10, 10) { 0.0 }

      p1 = PF2d::Vec[0.0, 9.0, 0.0]
      p2 = PF2d::Vec[4.0, 0.0, 0.0]
      p3 = PF2d::Vec[8.0, 9.0, 0.0]

      canvas.paint_triangle(p1, p2, p3, t1, t2, t3, texture, depth_buffer, tint)

      visual do
        puts
        puts canvas.to_s
      end

      canvas.to_s.decolorize.should eq(<<-GRID)
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
      canvas = TestGrid.new(10, 10)
      depth_buffer = PF2d::Grid(Float64).new(10, 10) { 0.0 }

      p1 = PF2d::Vec[2.0, 0.0, 0.0]
      p2 = PF2d::Vec[9.0, 5.0, 0.0]
      p3 = PF2d::Vec[0.0, 9.0, 0.0]

      canvas.paint_triangle(p1, p2, p3, t1, t2, t3, texture, depth_buffer, tint)

      visual do
        puts
        puts canvas.to_s
      end

      canvas.to_s.decolorize.should eq(<<-GRID)
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

    it "renders a left pointing triangle" do
      canvas = TestGrid.new(10, 10)
      depth_buffer = PF2d::Grid(Float64).new(10, 10) { 0.0 }

      p1 = PF2d::Vec[9.0, 0.0, 0.0]
      p2 = PF2d::Vec[0.0, 5.0, 0.0]
      p3 = PF2d::Vec[7.0, 9.0, 0.0]

      canvas.paint_triangle(p1, p2, p3, t1, t2, t3, texture, depth_buffer, tint)

      visual do
        puts
        puts canvas.to_s
      end

      canvas.to_s.decolorize.should eq(<<-GRID)
      ┌────────────────────┐
      │                  ██│
      │              ██████│
      │          ██████████│
      │        ██████████  │
      │    ██████████████  │
      │██████████████████  │
      │    ██████████████  │
      │        ████████    │
      │          ██████    │
      │              ██    │
      └────────────────────┘
      GRID
    end
  end
end
