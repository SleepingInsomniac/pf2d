require "../../spec_helper"

include PF2d

describe PF2d::Drawable do
  describe "#draw_line" do
    it "draws a line" do
      canvas = TestGrid.new(10, 10)
      canvas.draw_line(Vec[0, 0], Vec[9, 9], WHITE)
      result = canvas.to_s
      visual do
        puts
        puts result
      end
      result.decolorize.should eq(<<-GRID)
    ┌────────────────────┐
    │██                  │
    │  ██                │
    │    ██              │
    │      ██            │
    │        ██          │
    │          ██        │
    │            ██      │
    │              ██    │
    │                ██  │
    │                  ██│
    └────────────────────┘
    GRID
    end

    it "blends a line" do
      canvas = TestGrid.new(10, 10)
      canvas.draw_line(Vec[0, 0], Vec[9, 9], RGBA.new(255, 0, 0, 255))
      canvas.draw_line(Vec[3, 5], Vec[5, 3], RGBA.new(0, 255, 0, 127)) { |s, d| s.blend(d) }
      visual do
        puts
        puts canvas.to_s
      end
      canvas[4,4].should eq(RGBA[2155806975])
    end

    it "draws a scanline" do
      canvas = TestGrid.new(10, 3)
      canvas.scan_line(0, 1, 10, WHITE)
      result = canvas.to_s
      visual do
        puts
        puts result
      end
      result.decolorize.should eq(<<-GRID)
      ┌────────────────────┐
      │                    │
      │████████████████████│
      │                    │
      └────────────────────┘
      GRID
    end

    it "blends a scanline" do
      canvas = TestGrid.new(10, 3)
      canvas.scan_line(0, 1, 10, WHITE)
      canvas.scan_line(3, 1, 3, RGBA[0x00880088]) { |src, dst| src.blend(dst) }
      result = canvas.to_s
      visual do
        puts
        puts result
      end
      canvas[3,1].should eq(RGBA[2009036799])
    end
  end
end
