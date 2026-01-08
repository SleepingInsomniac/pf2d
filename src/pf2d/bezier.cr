module PF2d
  module Bezier
    macro [](*args)
      {% if args.size == 3 %}
        PF2d::Bezier::Quad.new({{args.splat}})
      {% elsif args.size == 4 %}
        PF2d::Bezier::Cubic.new({{args.splat}})
      {% else %}
        raise "Invalid number of arguments"
      {% end %}
    end
  end
end

require "./bezier/curve"
require "./bezier/quad"
require "./bezier/cubic"
