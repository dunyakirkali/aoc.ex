module Day17
  class Part1
    def self.run(steps)
      buffer = [0]
      pos = 0
      2017.times do |i|
        cur_len = buffer.length
        pos = ((pos + steps) % cur_len) + 1
        buffer.insert(pos, i + 1)
      end
      buffer[(pos + 1) % buffer.length]
    end
  end
end
