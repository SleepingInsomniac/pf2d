module PF2d
  abstract struct Matrix(T, W, H)
    # Gaussian elimination
    # https://www.geeksforgeeks.org/dsa/gaussian-elimination/
    def solve?
      return nil unless forward_eliminate
      back_substitute
    end

    private def pivot_row_for(k)
      pivot = k
      max = self[k, k].abs

      (k + 1).upto(H - 1) do |i|
        v = self[i, k].abs
        if v > max
          max = v
          pivot = i
        end
      end

      {pivot, max}
    end

    private def eliminate_below(k)
      (k + 1).upto(H - 1) do |i|
        factor = self[i, k] / self[k, k]

        (k + 1).upto(W - 1) do |j|
          self[i, j] -= factor * self[k, j]
        end

        self[i, k] = 0.0
      end
    end

    private def forward_eliminate
      unknowns = W - 1

      0.upto(unknowns - 1) do |k|
        pivot, max = pivot_row_for(k)
        return false if max < EPS

        swap_rows(k, pivot) if pivot != k
        eliminate_below(k)
      end

      true
    end

    private def back_substitute
      rhs = W - 1
      result = StaticArray(Float64, H).new(0.0)

      (H - 1).downto(0) do |i|
        sum = 0.0
        (i + 1).upto(H - 1) do |j|
          sum += self[i, j] * result[j]
        end

        result[i] = (self[i, rhs] - sum) / self[i, i]
      end

      result
    end
  end
end
