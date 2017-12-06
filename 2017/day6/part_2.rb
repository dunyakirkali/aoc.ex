module Day6
  class Part2
    def self.run(seq)
      @results = []
      @seq = seq

      while !@results.include?(@seq) do
        position = find
        redistribute(position)
      end

      index = @results.index(@seq)
      @results.length - index
    end

    def self.find
      max = @seq.max
      @seq.index(max)
    end

    def self.redistribute(pos)
      @results << @seq.dup
      position = pos
      to = @seq[position]
      @seq[position] = 0
      to.times do |i|
        position += 1
        position %= @seq.length
        @seq[position] += 1
      end
    end
  end
end
