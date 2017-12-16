module Day13
  class Part2
    def self.run(seq)
      @state = {}
      @delay = 0

      seq.each do |line|
        splits = line.split(": ")
        register = splits.first.to_i
        steps = splits.last.strip.to_i
        @state[register] = steps
      end

      while true do
        if @state.map { |key, val| severity(key, val, @delay) }.inject(0) { |sum,x| sum + x } == 0
          break
        else
          @delay += 1
        end
      end
      @delay
    end

    def self.severity(tick, depth, delay)
      if (tick + delay) % (2 * (depth -1)) == 0
        depth * (tick + delay)
      else
        0
      end
    end
  end
end
