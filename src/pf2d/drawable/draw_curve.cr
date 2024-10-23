module PF2d::Drawable(T)
  def draw_curve(curve : Bezier::Curve, value : T, samples : Int = 100)
    point = curve.p0
    0.upto(samples) do |x|
      t = x / samples
      next_point = curve.at(t)
      draw_line(point.to_i, next_point.to_i, value)
      point = next_point
    end
  end
end
