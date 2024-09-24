module PF2d
  VERSION = {% `shards version`.chomp.stringify %}
end

require "./pf2d/vec"
require "./pf2d/line"
require "./pf2d/matrix"
require "./pf2d/drawable"
