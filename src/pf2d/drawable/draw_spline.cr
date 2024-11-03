module PF2d::Drawable(T)
  def draw_spline(spline : QuadSpline, value : T, samples : Int = 100, closed : Bool = false)
    if closed
      spline.closed_curves { |curve| draw_curve(curve, value, samples) }
    else
      spline.curves { |curve| draw_curve(curve, value, samples) }
    end
  end
end
