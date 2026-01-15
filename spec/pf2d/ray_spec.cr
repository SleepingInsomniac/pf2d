require "../spec_helper"

include PF2d

describe Ray do
  describe "#intersect?" do
    it "intersects when both rays cross forward" do
      a = Ray[Vec[0.0, 0.0], Vec[1.0, 0.0]]
      b = Ray[Vec[5.0, -5.0], Vec[0.0, 1.0]]

      p = a.intersect?(b)

      p.should_not be_nil
      p.not_nil!.x.should be_close(5.0, 1e-6)
      p.not_nil!.y.should be_close(0.0, 1e-6)
    end

    it "returns nil when intersection is behind the ray" do
      a = Ray[Vec[0.0, 0.0], Vec[1.0, 0.0]]
      b = Ray[Vec[-5.0, -5.0], Vec[0.0, 1.0]]

      a.intersect?(b).should be_nil
    end

    it "returns nil for parallel rays" do
      a = Ray[Vec[0.0, 0.0], Vec[1.0, 0.0]]
      b = Ray[Vec[0.0, 1.0], Vec[1.0, 0.0]]

      a.intersect?(b).should be_nil
    end
  end
end
