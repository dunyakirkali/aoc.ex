module Day17
  class Part2
    def self.run(steps)
      buffer_length = 1
      pos = 0
      value_after_zero = 0

      50_000_000.times do |i|
        pre_pos = ((pos + steps) % buffer_length)
        value_after_zero = (i + 1) if pre_pos == 0
        pos = pre_pos + 1
        buffer_length += 1
      end

      value_after_zero
    end
  end
end
