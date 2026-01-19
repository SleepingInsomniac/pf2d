require "../spec_helper"

include PF2d

describe Tri do
  describe "#barycentric?" do
    it "returns the correct barycentric weights" do
      tri = Tri.new(Vec[0, 0], Vec[100, 0], Vec[50, 100])
      tri.barycentric?(Vec[50, 50]).should eq({0.25, 0.25, 0.5})
    end
  end
end
