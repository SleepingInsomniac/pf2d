require "../spec_helper"

include PF2d

canvas = TestGrid.new(10, 10)

describe Canvas do
  describe "#draw" do
    it "Draws another canvas onto itself" do
      c = TestGrid.new(2, 2)
      c.each_point { |p| c[p] = RGBA[0xFFFFFFFF] }
      canvas.draw(c, Vec[1, 1])
      visual { puts "\n" + canvas.to_s }
      canvas[1, 1].should eq(WHITE)
    end
  end
end
