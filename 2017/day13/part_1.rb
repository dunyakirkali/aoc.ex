module Day13
  class Part1
    def self.run(seq)
      @state = {}
      seq.each do |line|
        splits = line.split(": ")
        register = splits.first.to_i
        steps = splits.last.strip.to_i
        @state[register] = steps
      end
      @state.map { |key, val| severity(key, val) }.inject(0) { |sum,x| sum + x }
    end

    def self.severity(tick, depth)
      if tick % (2 * (depth -1)) == 0
        depth * tick
      else
        0
      end
    end
  end
end
