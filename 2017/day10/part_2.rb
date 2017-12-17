module Day10
  class Part2
    def self.run(length, seq)
      @curr_pos = 0
      @skip_size = 0
      @total_dist = 0
      input = (0..length - 1).to_a
      seq = seq.each_byte.to_a + [17, 31, 73, 47, 23]
      64.times do
        seq.each do |sub|
          part = input.slice!(@curr_pos, sub)
          input = part.reverse + input
          dist = (sub + @skip_size)
          @total_dist += dist
          input = input.rotate(dist)
          @skip_size += 1
        end
      end
      input = input.rotate(-1 * @total_dist)
      input.each_slice(16).map { |el| el.inject(:^) }.map { |y| y.to_s(16).rjust(2, '0') }.join
    end
  end
end
