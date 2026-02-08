require "../../spec_helper"

include PF2d

describe PF2d::Drawable do
  describe "#draw_circle" do
    it "draws a circle" do
      canvas = TestGrid.new(9, 9)
      canvas.draw_circle(Vec[4, 4], 4, WHITE)
      result = canvas.to_s
      display do
        puts
        puts result
      end
      result.decolorize.should eq(<<-GRID)
    ┌──────────────────┐
    │      ██████      │
    │    ██      ██    │
    │  ██          ██  │
    │██              ██│
    │██              ██│
    │██              ██│
    │  ██          ██  │
    │    ██      ██    │
    │      ██████      │
    └──────────────────┘
    GRID
    end
  end
end
