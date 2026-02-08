require "../../spec_helper"

include PF2d

describe PF2d::Drawable do
  describe "#draw_curve" do
    it "draws a curve" do
      canvas = TestGrid.new(9, 9)
      canvas.draw_curve(Bezier[Vec[0, 0], Vec[0, 10], Vec[10, 10], Vec[8, 0]], WHITE)
      result = canvas.to_s
      display do
        puts
        puts result
      end
      result.decolorize.should eq(<<-GRID)
    ┌──────────────────┐
    │██              ██│
    │██              ██│
    │██              ██│
    │██              ██│
    │████          ████│
    │  ██          ██  │
    │  ████      ████  │
    │      ████████    │
    │                  │
    └──────────────────┘
    GRID
    end
  end
end
