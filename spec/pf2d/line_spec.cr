require "../spec_helper"

include PF2d

describe Line do
  describe "#intersects" do
    it "returns the point at which this line intersects another" do
      Line[Vec[0, 2], Vec[2, 2]].intersects?(Line[Vec[1, 1], Vec[1, 3]]).should eq(Vec[1.0, 2.0])
    end
  end
end
