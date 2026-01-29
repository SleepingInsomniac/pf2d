require "../spec_helper"

include PF2d

describe Quad do
  describe "math" do
    it "Adds a number to its points" do
      result = Quad[Vec[1,1], Vec[2,2], Vec[3,3], Vec[4,4]] + Vec[1,1]
      result.should eq(Quad[Vec[2,2], Vec[3,3], Vec[4,4], Vec[5,5]])
    end
  end
end
