require "../spec_helper"

include PF2d

describe Canvas do
  it "draws a curve" do
    canvas = TestCanvas.new(9, 9) { false }
    canvas.draw_curve(Bezier[Vec[0, 0], Vec[0, 10], Vec[10, 10], Vec[8, 0]], true)
    result = canvas.to_s
    display do
      puts
      puts result
    end
    result.should eq(<<-GRID)
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

  it "draws a circle" do
    canvas = TestCanvas.new(9, 9) { false }
    canvas.draw_circle(Vec[4, 4], 4, true)
    result = canvas.to_s
    display do
      puts
      puts result
    end
    result.should eq(<<-GRID)
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

  it "draws a line" do
    canvas = TestCanvas.new(10, 10) { false }
    canvas.draw_line(Vec[0, 0], Vec[9, 9], true)
    result = canvas.to_s
    display do
      puts
      puts result
    end
    result.should eq(<<-GRID)
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
