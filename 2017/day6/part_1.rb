module Day6
  class Part1
    def self.run(seq)
      @results = []
      @seq = seq
      @counter = 0

      while !@results.include?(@seq) do
        position = find
        redistribute(position)
      end

      @counter
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
      @counter += 1
    end
  end
end
