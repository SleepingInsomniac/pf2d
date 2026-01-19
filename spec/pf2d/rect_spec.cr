require "../spec_helper"

include PF2d

describe Rect do
  describe "#covers?" do
    # Points
    it "covers a point inside the rect" do
      r = Rect[10, 20, 5, 4]
      r.covers?(Vec[12, 22]).should be_true
    end

    it "covers a point on the top and left edge" do
      r = Rect[5, 5, 5, 5]
      r.covers?(Vec[5, 5]).should be_true
      r.covers?(Vec[4, 4]).should be_false
    end

    it "covers a point on the bottom and right edge" do
      r = Rect[5, 5, 5, 5]
      r.covers?(Vec[9, 9]).should be_true
      r.covers?(Vec[10, 10]).should be_false
    end

    it "does not cover a point outside the rect" do
      r = Rect[10, 20, 5, 4]
      r.covers?(Vec[9, 20]).should be_false
      r.covers?(Vec[10, 19]).should be_false
      r.covers?(Vec[16, 20]).should be_false
      r.covers?(Vec[10, 25]).should be_false
    end

    # Rects
    it "covers another rect fully contained" do
      outer = Rect[10, 20, 5, 4]
      inner = Rect[11, 21, 2, 2]
      same  = Rect[10, 20, 5, 4]

      outer.covers?(inner).should be_true
      outer.covers?(same).should be_true
    end

    it "does not cover another rect that extends outside" do
      outer = Rect[10, 20, 5, 4]

      outer.covers?(Rect[9, 20, 5, 4]).should be_false
      outer.covers?(Rect[10, 19, 5, 4]).should be_false
      outer.covers?(Rect[11, 21, 5, 4]).should be_false
      outer.covers?(Rect[10, 21, 5, 4]).should be_false
    end
  end

  describe "#merge" do
    it "returns a rect that covers both rectangles" do
      a = Rect[1, 1, 10, 10]
      b = Rect[5, 5, 10, 10]

      m = a.merge(b)

      m.top_left.should eq(Vec[1, 1])
      m.bottom_right.should eq(Vec[14, 14])
      m.size.should eq(Vec[14, 14])
    end

    it "keeps the same bounds when merging with a contained rect" do
      outer = Rect[0, 0, 10, 10]
      inner = Rect[2, 3, 4, 5]

      m = outer.merge(inner)

      m.top_left.should eq(outer.top_left)
      m.size.should eq(outer.size)
    end

    it "is the same both ways" do
      a = Rect[10, 20, 5, 4]
      b = Rect[12, 18, 10, 3]

      a.merge(b).should eq(b.merge(a))
    end

    it "handles disjoint rects by spanning the gap" do
      a = Rect[0, 0, 2, 2]
      b = Rect[10, 10, 1, 1]

      m = a.merge(b)

      m.top_left.should eq(Vec[0, 0])
      m.bottom_right.should eq(Vec[10, 10])
      m.size.should eq(Vec[11, 11])
    end
  end

  describe "#map_points" do
    it "yields (source, dest) point pairs for each dest pixel" do
      src = Rect[10, 20, 4, 4]
      dst = Rect[0, 0, 2, 2]

      pairs = [] of {Vec2(Int32), Vec2(Int32)}
      src.map_points(dst) do |s, d|
        pairs << {s, d}
      end

      pairs.should eq([
        {Vec[10, 20], Vec[0, 0]},
        {Vec[12, 20], Vec[1, 0]},
        {Vec[10, 22], Vec[0, 1]},
        {Vec[12, 22], Vec[1, 1]},
      ])
    end

    it "accounts for dest top_left offset" do
      src = Rect[0, 0, 4, 4]
      dst = Rect[5, 7, 2, 2]

      pairs = [] of {Vec2(Int32), Vec2(Int32)}
      src.map_points(dst) do |s, d|
        pairs << {s, d}
      end

      pairs.should eq([
        {Vec[0, 0], Vec[5, 7]},
        {Vec[2, 0], Vec[6, 7]},
        {Vec[0, 2], Vec[5, 8]},
        {Vec[2, 2], Vec[6, 8]},
      ])
    end

    it "yields dest.width * dest.height pairs in row-major order" do
      src = Rect[0, 0, 6, 6]
      dst = Rect[0, 0, 3, 2]

      ds = [] of Vec2(Int32)
      src.map_points(dst) do |_, d|
        ds << d
      end

      ds.size.should eq(3 * 2)
      ds.should eq([
        Vec[0, 0], Vec[1, 0], Vec[2, 0],
        Vec[0, 1], Vec[1, 1], Vec[2, 1],
      ])
    end
  end

  describe "#intersection?" do
    it "returns nil if the rects do not intersect" do
      Rect[0, 0, 10, 10].intersection?(Rect[10, 10, 10, 10]).should be_nil
    end

    it "returns a rect that covers the intersection" do
      Rect[0, 0, 10, 10].intersection?(Rect[5, 5, 10, 10]).should eq(Rect[5,5,5,5])
    end
  end
end
