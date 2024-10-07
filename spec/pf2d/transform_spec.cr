require "../spec_helper"

include PF2d

describe Transform do
  describe "#translate" do
    it "creates the same matrix as matrix multiplication" do
      t = Transform.new
      t.translate(-1.0, -2.0).rotate(0.5).scale(1.1).translate(1.0, 2.0)

      m = Transform.translation(-1.0, -2.0)
      m = Transform.rotation(0.5) * m
      m = Transform.scale(1.1, 1.1) * m
      m = Transform.translation(1.0, 2.0) * m

      t.matrix.should eq(m)
    end
  end
end
