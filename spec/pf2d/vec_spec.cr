require "../spec_helper"

include PF2d

describe Vec do
  it "multiplies" do
    (Vec[2, 2] * Vec[2, 2]).should eq(Vec[4, 4])
  end

  it "cross multiplies" do
    Vec[1, 2].cross(Vec[1, 2]).should eq(Vec[0, 0])
  end

  it "multiplies with a matrix" do
    (Vec[1, 2, 3] * Matrix[1, 2, 3, 4, 5, 6, 7, 8, 9]).should eq(Vec[14, 32, 50])
  end
end
