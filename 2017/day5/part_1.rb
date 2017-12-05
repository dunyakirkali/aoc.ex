module Day5
  class Part1
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
      @jumps[@cursor] += 1
      @cursor += steps
    end
  end
end
