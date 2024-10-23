module PF2d
  VERSION = {% `shards version`.chomp.stringify %}
end

require "./pf2d/*"
