require "../spec_helper"

include PF2d

Matrix.define(2, 2)
Matrix.define(4, 4)

describe Matrix do
  it "is a Matrix" do
    m = Mat2x2[
      0, 1,
      1, 0,
    ]

    m.is_a?(Matrix).should eq(true)
  end

  it "Creates a square matrix with bracket notation" do
    m = Mat2x2[
      0, 1,
      1, 0,
    ]

    m.class.should eq(Mat2x2(Int32))
    m[0, 0].should eq(0)
    m[0, 1].should eq(1)
    m[1, 0].should eq(1)
    m[1, 1].should eq(0)
  end

  describe "#*" do
    it "returns the same matrix when multiplied by identity" do
      mat = Mat4x4[
        1.0, 2.0, 3.0, 4.0,
        1.0, 2.0, 3.0, 4.0,
        1.0, 2.0, 3.0, 4.0,
        1.0, 2.0, 3.0, 4.0,
      ]

      mat.class.should eq(Mat4x4(Float64))

      ident = Mat4x4[
        1.0, 0.0, 0.0, 0.0,
        0.0, 1.0, 0.0, 0.0,
        0.0, 0.0, 1.0, 0.0,
        0.0, 0.0, 0.0, 1.0,
      ]

      result = mat * ident
      (mat == result).should be_true
    end

    it "multiplies different types" do
      m1 = Mat2x2[
        1, 2,
        3, 4
      ]

      m2 = Mat2x2[
        2.0, 0.0,
        0.0, 2.0
      ]

      m3 = Mat2x2[
        2.0, 4.0,
        6.0, 8.0
      ]

      (m1 * m2).should eq(m3)
    end
  end

  describe "#size" do
    it "returns the size of the matrix" do
      mat = Mat2x2[
        1, 2,
        3, 4,
      ]

      mat.width.should eq(2)
    end
  end

  describe "#==" do
    it "accurately shows equality" do
      m1 = Mat2x2[
        1, 1,
        1, 1,
      ]

      m2 = Mat2x2[
        1, 1,
        1, 1,
      ]

      m3 = Mat2x2[
        2, 2,
        2, 2,
      ]

      (m1 == m2).should eq(true)
      (m1 == m3).should eq(false)
    end
  end
end
