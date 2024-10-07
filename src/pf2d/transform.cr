module PF2d
  class Transform
    property matrix : PF2d::Matrix(Float64, 9)

    def self.identity
      PF2d::Matrix[
        1.0, 0.0, 0.0,
        0.0, 1.0, 0.0,
        0.0, 0.0, 1.0,
      ]
    end

    # Returns a matrix representing a 2d translation
    def self.translation(x : Number, y : Number)
      PF2d::Matrix[
        1.0, 0.0, x.to_f64,
        0.0, 1.0, y.to_f64,
        0.0, 0.0, 1.0,
      ]
    end

    # Returns a matrix representing a 2d scaling
    def self.scale(x : Number, y : Number)
      PF2d::Matrix[
        x.to_f64, 0.0, 0.0,
        0.0, y.to_f64, 0.0,
        0.0, 0.0, 1.0,
      ]
    end

    # Returns a matrix representing a 2d rotation
    def self.rotation(angle : Number)
      cos = Math.cos(angle)
      sin = Math.sin(angle)
      PF2d::Matrix[
        cos, -sin, 0.0,
        sin, cos, 0.0,
        0.0, 0.0, 1.0,
      ]
    end

    # Returns a matrix representing a 2d shear
    def self.shear(x : Number, y : Number)
      PF2d::Matrix[
        1.0, x.to_f64, 0.0,
        y.to_f64, 1.0, 0.0,
        0.0, 0.0, 1.0,
      ]
    end

    # Return a new inverted version of the given *matrix*
    def self.invert(matrix : PF2d::Matrix)
      det = matrix[0, 0] * (matrix[1, 1] * matrix[2, 2] - matrix[1, 2] * matrix[2, 1]) -
            matrix[1, 0] * (matrix[0, 1] * matrix[2, 2] - matrix[2, 1] * matrix[0, 2]) +
            matrix[2, 0] * (matrix[0, 1] * matrix[1, 2] - matrix[1, 1] * matrix[0, 2])

      idet = 1.0 / det

      PF2d::Matrix[
        (matrix[1, 1] * matrix[2, 2] - matrix[1, 2] * matrix[2, 1]) * idet,
        (matrix[2, 0] * matrix[1, 2] - matrix[1, 0] * matrix[2, 2]) * idet,
        (matrix[1, 0] * matrix[2, 1] - matrix[2, 0] * matrix[1, 1]) * idet,

        (matrix[2, 1] * matrix[0, 2] - matrix[0, 1] * matrix[2, 2]) * idet,
        (matrix[0, 0] * matrix[2, 2] - matrix[2, 0] * matrix[0, 2]) * idet,
        (matrix[0, 1] * matrix[2, 0] - matrix[0, 0] * matrix[2, 1]) * idet,

        (matrix[0, 1] * matrix[1, 2] - matrix[0, 2] * matrix[1, 1]) * idet,
        (matrix[0, 2] * matrix[1, 0] - matrix[0, 0] * matrix[1, 2]) * idet,
        (matrix[0, 0] * matrix[1, 1] - matrix[0, 1] * matrix[1, 0]) * idet,
      ]
    end

    def initialize
      @matrix = Transform.identity
    end

    def initialize(@matrix)
    end

    # =============

    # Reset the transformation to the identity matrix
    def reset
      @matrix = Transform.identity
      self
    end

    # =============
    # = translate =
    # =============

    # Translate by *x* and *y*
    def translate(x : Number, y : Number)
      @matrix = Transform.translation(x, y) * @matrix
      self
    end

    # ditto
    def translate(point : PF2d::Vec)
      translate(point.x, point.y)
    end

    # ==========
    # = rotate =
    # ==========

    # Rotate by *angle* (in radians)
    def rotate(angle : Number)
      @matrix = Transform.rotation(angle) * @matrix
      self
    end

    # =========
    # = scale =
    # =========

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

    # =========
    # = shear =
    # =========

    # Shear by *x* and *y*
    def shear(x : Number, y : Number)
      @matrix = Transform.shear(x, y) * @matrix
      self
    end

    # ditto
    def shear(point : PF2d::Vec)
      shear(point.x, point.y)
    end

    # ==========

    # Return the boudning box of the current transformation matrix
    def bounding_box(x : Number, y : Number)
      top_left = apply(0.0, 0.0)
      top_right = apply(x.to_f, 0.0)
      bot_right = apply(x.to_f, y.to_f)
      bot_left = apply(0.0, y.to_f)

      xs = Float64[top_left.x, top_right.x, bot_right.x, bot_left.x]
      ys = Float64[top_left.y, top_right.y, bot_right.y, bot_left.y]

      {PF2d::Vec[xs.min, ys.min], PF2d::Vec[xs.max, ys.max]}
    end

    # Invert the transformation
    def invert
      @matrix = Transform.invert(@matrix)
      self
    end

    def apply(x : Number, y : Number)
      result = PF2d::Vec[x, y, 1.0] * @matrix
      PF2d::Vec[result.x, result.y]
    end

    def apply(point : PF2d::Vec)
      apply(point.x, point.y)
    end
  end
end
