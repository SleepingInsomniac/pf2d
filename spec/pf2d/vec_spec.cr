require "../spec_helper"

include PF2d

describe Vec do
  describe ".from_angle" do
    it "returns the correct normalized vector" do
      Vec.from_angle(0).should eq(Vec[1.0, 0.0])
    end
  end

  describe "#*" do
    it "multiplies 2 vectors" do
      v1 = Vec[1, 2]
      v2 = Vec[2, 2]
      (v1 * v2).should eq(Vec[2, 4])
    end
  end

  describe "#magnitude" do
    it "returns the magnitude a vector" do
      v1 = Vec[2, 2]
      v1.magnitude.should eq(2.8284271247461903)
    end
  end

  describe "#dot" do
    it "returns a known dot product" do
      v1 = Vec[6, 2, -1]
      v2 = Vec[5, -8, 2]
      v1.dot(v2).should eq(12)
    end
  end

  describe "#cross" do
    it "returns a known cross product" do
      v1 = Vec[0, 0, 2]
      v2 = Vec[0, 2, 0]
      v1.cross(v2).should eq(Vec[-4, 0, 0])
    end
  end

  describe "#x" do
    it "returns the x positional value" do
      v1 = Vec[1, 2]
      v1.x.should eq(1)
    end
  end

  describe "standard operations" do
    it "adds" do
      v1 = Vec[1, 2]
      v2 = Vec[3, 4]
      (v1 + v2).should eq(Vec[4, 6])
    end

    it "substracts" do
      v1 = Vec[4, 5]
      v2 = Vec[3, 4]
      (v1 - v2).should eq(Vec[1, 1])
    end

    it "does modulus" do
      v1 = Vec[5, 10]
      v2 = Vec[3, 3]
      (v1 % v2).should eq(Vec[2, 1])
    end

    it "does division" do
      v1 = Vec[5, 5]
      (v1 / 2).should eq(Vec[2.5, 2.5])
    end

    it "does integer division" do
      v1 = Vec[5, 5]
      (v1 // 2).should eq(Vec[2, 2])
    end

    it "applies exponents" do
      v = Vec[2, 2] ** 5
      v.should eq(Vec[32, 32])
    end
  end

  describe "#-" do
    it "negates" do
      v = Vec[1, 1]
      v = -v
      v.should eq(Vec[-1, -1])
    end
  end

  describe "#sum" do
    it "returns all components added together" do
      v = Vec[1, 2, 3]
      v.sum.should eq(6)
    end
  end

  describe "#abs" do
    it "returns the absolute value" do
      v = Vec[-1, -1]
      v.abs.should eq(Vec[1, 1])
    end
  end

  describe "type conversion" do
    it "converts float to int" do
      v = Vec[1.5, 2.5]
      v.to_i32.should eq(Vec[1, 2])
    end
  end

  describe "Matrix multiplication" do
    it "returns the scaled value when multiplied by an identity matrix" do
      v = Vec[1, 2]
      m = Matrix[
        1, 0,
        0, 1,
      ]
      (v * m).should eq(v)
      m = Matrix[
        2, 0,
        0, 1,
      ]
      (v * m).should eq(Vec[2, 2])
    end

    it "multiplies correctly" do
      v = Vec[2, 1, 3]
      m = Matrix[
        1, 2, 3,
        4, 5, 6,
        7, 8, 9,
      ]
      (v * m).should eq(Vec[13, 31, 49])
    end
  end

  describe "#to" do
    it "converts to a given type" do
      Vec[3.0, 3.0].to(Int32).should eq(Vec[3, 3])
    end
  end
end
