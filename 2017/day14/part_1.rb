require_relative "../day10/part_2"

module Day14
  class Part1
    def self.run(seq)

      @sum = 0
      for i in 0..127 do
        va = ::Day10::Part2.run(256, "amgozmfv-#{i}").split("").map { |s| s.hex.chr.unpack('b4').first.reverse }.join
        puts va
        va.split("").each do |ch|
          @sum += 1 if ch == '1'
        end
      end
      @sum
    end
  end
end
