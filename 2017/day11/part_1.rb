module Day11
  class Part1
    def self.run(seq)
      center = [0, 0, 0]
      location = [0, 0, 0]
      input = seq.split(",")
      input.each do |char|
        case char
        when "n"
          location[0] += 1
          location[1] -= 1
          # location[2] -= 0
        when "ne"
          # location[0] += 0
          location[1] -= 1
          location[2] += 1
        when "se"
          location[0] -= 1
          # location[1] -= 0
          location[2] += 1
        when "s"
          location[0] -= 1
          location[1] += 1
          # location[2] += 0
        when "sw"
          # location[0] -= 0
          location[1] += 1
          location[2] -= 1
        when "nw"
          location[0] += 1
          # location[1] += 0
          location[2] -= 1
        end
      end
      [(center[0] - location[0]).abs, (center[1] - location[1]).abs, (center[2] - location[2]).abs].max
    end
  end
end
