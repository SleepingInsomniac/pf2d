module PF2d
  struct ThreadedBinaryTree(T)
    # Using a struct avoids costly allocation and garbage collection
    struct Node(T)
      property value : T
      property left_index : UInt16? = nil
      property right_index : UInt16? = nil
      property thread_index : UInt16? = nil

      def initialize(@value, @left_index = nil, @right_index = nil, @thread_index = nil)
      end

      def leftmost(values : Enumerable(Node(T))) : Node(T)
        if l = left_index
          values[l].leftmost(values)
        else
          self
        end
      end

      def next(values : Enumerable(Node(T))) : Node(T)?
        thread_index.try { |ti| values[ti] }
      end

      def insert(values : Enumerable(Node(T)), new_value : T, compare : (T, T) -> Int32, on_collision : (T, T -> T) | Nil = nil, at : UInt16 = 0, pred_index : UInt16? = nil)
        case compare.call(new_value, @value)
        when .< 0
          # Insert to the left of node on index "at"
          if li = @left_index
            # Node exists, update the predecessor and continue traversal
            pred_index.try do |pi|
              pred_index = at if compare.call(@value, values[pi].value) < 0
            end
            values[li].insert(values, new_value, at: li, pred_index: pred_index, compare: compare, on_collision: on_collision)
          else
            # Create the new node, initial thread points to parent
            values << Node(T).new(new_value, thread_index: at)
            @left_index = (values.size - 1).to_u16
            pred_index.try do |pi|
              # If the predecessor exists update its thread to point to the new node's index (left index of at)
              pred = values[pi]
              pred.thread_index = @left_index
              values[pi] = pred
            end
            values[at] = self
          end
        when .> 0
          # Insert to the right of node on index "at"
          if ri = @right_index
            # Node exists, continue traversal, current node "at" become predecessor
            values[ri].insert(values, new_value, at: ri, pred_index: at, compare: compare, on_collision: on_collision)
          else
            # Create the new node, initial thread points to parent's thread
            values << Node(T).new(new_value, thread_index: @thread_index)
            @right_index = (values.size - 1).to_u16
            # Update current node's thread to be the new node
            @thread_index = @right_index
            values[at] = self
          end
        when .== 0
          on_collision.try do |proc|
            # Update the value on comparision collision
            new_value = proc.call(@value, new_value)
            @value = new_value
            values[at] = self
          end
        end
      end
    end

    include Enumerable(T)

    property compare : T, T -> Int32
    property on_collision : (T, T -> T) | Nil
    property values : Array(Node(T)) = Array(Node(T)).new

    def initialize(@compare, @on_collision)
    end

    def initialize(&compare : (T, T) -> Int32)
      @compare = compare
    end

    def clear
      @values.clear
    end

    def <<(value : T)
      if @values.size == 0u16
        @values << Node(T).new(value)
      else
        @values[0].insert(@values, value, at: 0u16, compare: @compare, on_collision: @on_collision)
      end
    end

    def first
      @values[0].leftmost(@values)
    end

    def each(&)
      return if @values.size == 0

      ptr = @values[0].leftmost(@values)

      until ptr.nil?
        yield ptr.value
        ptr = ptr.next(@values)
      end
    end
  end
end
