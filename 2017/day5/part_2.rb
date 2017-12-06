module Day5
  class Part2
    def self.run(jumps)
      @cursor = 0
      @counter = 0
      @jumps = jumps.map { |jump| jump.to_i }
      while @cursor < @jumps.count && @cursor > -1
        step
      end
      @counter
    end

    def self.step
      @counter += 1
      steps = @jumps[@cursor]
      change(steps)
      @cursor += steps
    end

    def self.change(steps)
      if steps >= 3
        @jumps[@cursor] -= 1
      else
        @jumps[@cursor] += 1
      end
    end
  end
end
