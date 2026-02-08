require "../../spec_helper"

include PF2d

describe PF2d::Drawable do
  describe "#draw_line" do
    it "draws a line" do
      canvas = TestGrid.new(10, 10)
      canvas.draw_line(Vec[0, 0], Vec[9, 9], WHITE)
      result = canvas.to_s
      display do
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
  end
end
