require "../spec_helper"

include PF2d

describe Circle do
  describe "#contains?" do
    it "returns true for a point inside the cirlce" do
      Circle[0.0, 0.0, 5.0].contains?(Vec[0.0, 0.0]).should eq(true)
    end

    it "returns false for a point outside the cirlce" do
      Circle[0.0, 0.0, 5.0].contains?(Vec[5.1, 5.1]).should eq(false)
    end
  end
end
