require 'matrix'

module Day2
  class Part2
    def self.run(matrix)
      sum = 0
      matrix.row_count.times do |row_index|
        row = matrix.row(row_index)
        pair = find_pair(row)
        sum += pair.last / pair.first
      end
      sum
    end

    def self.find_pair(row)
      row.each do |item_1|
        row.each do |item_2|
          if item_1 % item_2 == 0 && item_1 != item_2
            return [item_1, item_2].sort
          end
        end
      end
    end
  end
end
