module PF2d
  class Transform
    Matrix.define(3, 3)
    Mat3x3.define_mul(3)
    Matrix.define(9, 8)

    property matrix : Mat3x3(Float64)

    def self.identity
      Mat3x3[
        1.0, 0.0, 0.0,
        0.0, 1.0, 0.0,
        0.0, 0.0, 1.0,
      ]
    end

    # Returns a matrix representing a 2d translation
    def self.translation(x : Number, y : Number)
      Mat3x3[
        1.0, 0.0, x.to_f64,
        0.0, 1.0, y.to_f64,
        0.0, 0.0, 1.0,
      ]
    end

    # Returns a matrix representing a 2d scaling
    def self.scale(x : Number, y : Number)
      Mat3x3[
        x.to_f64, 0.0, 0.0,
        0.0, y.to_f64, 0.0,
        0.0, 0.0, 1.0,
      ]
    end

    # Returns a matrix representing a 2d rotation
    def self.rotation(angle : Number)
      cos = Math.cos(angle)
      sin = Math.sin(angle)
      Mat3x3[
        cos, -sin, 0.0,
        sin, cos, 0.0,
        0.0, 0.0, 1.0,
      ]
    end

    # Returns a matrix representing a 2d shear
    def self.shear(x : Number, y : Number)
      Mat3x3[
        1.0, x.to_f64, 0.0,
        y.to_f64, 1.0, 0.0,
        0.0, 0.0, 1.0,
      ]
    end

    # https://docs.opencv.org/4.x/d9/dab/tutorial_homography.html
    def self.planar_perspective(src : Quad, dst : Quad)
      m = Mat9x8(Float64).new
      src_pts = src.points
      dst_pts = dst.points
      row = 0
      0.upto(3) do |i|
        x, y = src_pts[i].x, src_pts[i].y
        u, v = dst_pts[i].x, dst_pts[i].y

        m[row, 0] = x
        m[row, 1] = y
        m[row, 2] = 1.0
        m[row, 3] = 0.0
        m[row, 4] = 0.0
        m[row, 5] = 0.0
        m[row, 6] = -x * u
        m[row, 7] = -y * u
        m[row, 8] = u
        row += 1

        m[row, 0] = 0.0
        m[row, 1] = 0.0
        m[row, 2] = 0.0
        m[row, 3] = x
        m[row, 4] = y
        m[row, 5] = 1.0
        m[row, 6] = -x * v
        m[row, 7] = -y * v
        m[row, 8] = v
        row += 1
      end

      if r = m.solve?
        Mat3x3[
          r[0], r[1], r[2],
          r[3], r[4], r[5],
          r[6], r[7], 1.0,
        ]
      else
        identity
      end
    end

    # Return a new inverted version of the given *matrix*
    def self.invert(matrix : Mat3x3)
      det = matrix[0, 0] * (matrix[1, 1] * matrix[2, 2] - matrix[2, 1] * matrix[1, 2]) -
            matrix[0, 1] * (matrix[1, 0] * matrix[2, 2] - matrix[1, 2] * matrix[2, 0]) +
            matrix[0, 2] * (matrix[1, 0] * matrix[2, 1] - matrix[1, 1] * matrix[2, 0])

      return identity if det.abs < EPS
      idet = 1.0 / det

      Mat3x3[
        (matrix[1, 1] * matrix[2, 2] - matrix[2, 1] * matrix[1, 2]) * idet,
        (matrix[0, 2] * matrix[2, 1] - matrix[0, 1] * matrix[2, 2]) * idet,
        (matrix[0, 1] * matrix[1, 2] - matrix[0, 2] * matrix[1, 1]) * idet,

        (matrix[1, 2] * matrix[2, 0] - matrix[1, 0] * matrix[2, 2]) * idet,
        (matrix[0, 0] * matrix[2, 2] - matrix[0, 2] * matrix[2, 0]) * idet,
        (matrix[1, 0] * matrix[0, 2] - matrix[0, 0] * matrix[1, 2]) * idet,

        (matrix[1, 0] * matrix[2, 1] - matrix[2, 0] * matrix[1, 1]) * idet,
        (matrix[2, 0] * matrix[0, 1] - matrix[0, 0] * matrix[2, 1]) * idet,
        (matrix[0, 0] * matrix[1, 1] - matrix[1, 0] * matrix[0, 1]) * idet,
      ]
    end

    def initialize
      @matrix = Transform.identity
    end

    def initialize(@matrix)
    end

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    # Reset the transformation to the identity matrix
    def reset
      @matrix = Transform.identity
      self
    end

    # translate ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    # Translate by *x* and *y*
    def translate(x : Number, y : Number)
      @matrix = Transform.translation(x, y) * @matrix
      self
    end

    # ditto
    def translate(point : PF2d::Vec)
      translate(point.x, point.y)
    end

    # rotate ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    # Rotate by *angle* (in radians)
    def rotate(angle : Number)
      @matrix = Transform.rotation(angle) * @matrix
      self
    end

    # scale ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    # Scale by *x* and *y*
    def scale(x : Number, y : Number)
      @matrix = Transform.scale(x, y) * @matrix
      self
    end

    # ditto
    def scale(point : PF2d::Vec)
      scale(point.x, point.y)
    end

    # Scale both x and y by *n*
    def scale(n : Number)
      scale(n, n)
    end

    # shear ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    # Shear by *x* and *y*
    def shear(x : Number, y : Number)
      @matrix = Transform.shear(x, y) * @matrix
      self
    end

    # ditto
    def shear(point : PF2d::Vec)
      shear(point.x, point.y)
    end

    def distort(src : Quad, dst : Quad)
      @matrix = Transform.planar_perspective(src, dst) * @matrix
      self
    end

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    # Return the boudning box of the current transformation matrix
    def bounding_box(x : Number, y : Number)
      top_left  = apply(0.0, 0.0)
      top_right = apply(x.to_f, 0.0)
      bot_right = apply(x.to_f, y.to_f)
      bot_left  = apply(0.0, y.to_f)

      xs = {top_left.x, top_right.x, bot_right.x, bot_left.x}
      ys = {top_left.y, top_right.y, bot_right.y, bot_left.y}

      {PF2d::Vec[xs.min, ys.min], PF2d::Vec[xs.max, ys.max]}
    end

    # Invert the transformation
    def invert
      @matrix = Transform.invert(@matrix)
      self
    end

    def apply(x : Number, y : Number)
      v = PF2d::Vec[x.to_f, y.to_f, 1.0]
      x2 = @matrix[0, 0] * v.x + @matrix[0, 1] * v.y + @matrix[0, 2] * v.z
      y2 = @matrix[1, 0] * v.x + @matrix[1, 1] * v.y + @matrix[1, 2] * v.z
      w  = @matrix[2, 0] * v.x + @matrix[2, 1] * v.y + @matrix[2, 2] * v.z

      PF2d::Vec[x2 / w, y2 / w]
    end

    def apply(point : PF2d::Vec)
      apply(point.x, point.y)
    end

    def apply(points : Enumerable(PF2d::Vec))
      points.map { |p| apply(p) }
    end

    def apply(points : Enumerable(PF2d::Vec), &)
      points.each { |p| yield(apply(p)) }
    end
  end
end
