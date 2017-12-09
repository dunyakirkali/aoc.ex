require 'matrix'

module Day2
  class Part1
    def self.run(matrix)
      sum = 0
      matrix.row_count.times do |row_index|
        row = matrix.row(row_index)
        min = row.min
        max = row.max
        sum += max - min
      end
      sum
    end
  end
end
