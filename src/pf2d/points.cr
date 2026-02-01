module PF2d
  abstract struct Points(N)
    # Defines a common API of methods operating on points. This is implemented as a macro definition
    # for optimization by avoiding extra data structures, and unrolling.
    macro inherited
      {% base_type = @type.name.gsub(/\([^\)]+\)/, "").id %}
      {% points = (1..N).map { |n| "@p#{n}" } %}

      def self.[]({{ (1..N).map { |n| "p#{n} : T" }.join(", ").id }})
        new({{ (1..N).map { |n| "p#{n}" }.join(", ").id }})
      end

      {% for n in 1..N %}
        property p{{n}} : T
      {% end %}

      def initialize({{ points.map { |p| "#{p.id} : T" }.join(", ").id }})
      end

      def points
        { {{points.join(", ").id}} }
      end

      def point_pointers
        { {{points.map { |p| "pointerof(#{p.id})" }.join(", ").id}} }
      end

      {% for op in %w[* &* / // + &+ - % **] %}
        # Applies `{{op.id}}` to all points of this shape
        def {{ op.id }}(other)
          {{base_type}}.new({{ points.map { |p| "#{p.id} #{op.id} other" }.join(", ").id }})
        end
      {% end %}

      {% for op in %w[floor ceil - abs] %}
        def {{ op.id }}
          {{base_type}}.new({{ points.map { |p| "#{p.id}.#{op.id}" }.join(", ").id }})
        end
      {% end %}

      def round(precision = 0)
        {{base_type}}.new({{ points.map { |p| "#{p.id}.round(precision)" }.join(", ").id }})
      end

      def centroid
        {{ points.join(" + ").id }} / {{ N }}
      end

      {% for c in %w[x y z] %}
        @[AlwaysInline]
        def min_{{c.id}}
          m = @p1.{{c.id}}
          {% for i in 2..N %}
            m = @p{{i}}.{{c.id}} if @p{{i}}.{{c.id}} < m
          {% end %}
          m
        end

        @[AlwaysInline]
        def max_{{c.id}}
          m = @p1.{{c.id}}
          {% for i in 2..N %}
            m = @p{{i}}.{{c.id}} if @p{{i}}.{{c.id}} > m
          {% end %}
          m
        end
      {% end %}

      def bounding_rect
        lx, ly = min_x, min_y
        Rect[
          Vec[lx, ly],
          Vec[max_x - lx + 1, max_y - ly + 1]
        ]
      end
    end
  end
end
