module Day10
  class Part1
    def self.run(length, seq)
      @curr_pos = 0
      @skip_size = 0
      @total_dist = 0
      input = (0..length - 1).to_a
      seq.each do |sub|
        part = input.slice!(@curr_pos, sub)
        input = part.reverse + input
        dist = (sub + @skip_size)
        @total_dist += dist
        input = input.rotate(dist)
        @skip_size += 1
      end
      first_two = input.rotate(-1 * @total_dist).first(2)
      first_two[0] * first_two[1]
    end
  end
end
