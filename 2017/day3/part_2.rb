module Day3
  class Part2
    @mat = {}

    def self.run(destination)
      @mat = {}
      @destination = destination
      calculate_board_size

      arr = (1..@board_size).step(2).to_a

      arr.each_with_index do |ss, index|
        if ss == 1
          @mat[1] = [0, 0, 1]
        else
          increment_previous
          fill_mat_for_layer(ss)
        end
      end
      @mat[destination].last
    end

    def self.increment_previous
      @mat.each do |key, value|
        value[0] = value[0] + 1
        value[1] = value[1] + 1
      end
    end

    def self.calculate_board_size
      size = 1
      loop do
        break if @destination <= size * size
        size += 2
      end
      @board_size = size
    end

    def self.fill_mat_for_layer(ss)
      loop do
        curr = @mat[@mat.count]
        break if curr[0] == ss - 1
        @mat[@mat.count + 1] = [curr[0] + 1, curr[1], calculate_sum(curr[0] + 1, curr[1])]
      end

      loop do
        curr = @mat[@mat.count]
        break if curr[1] == 0
        @mat[@mat.count + 1] = [curr[0], curr[1] - 1, calculate_sum(curr[0], curr[1] - 1)]
      end

      loop do
        curr = @mat[@mat.count]
        break if curr[0] == 0
        @mat[@mat.count + 1] = [curr[0] - 1, curr[1], calculate_sum(curr[0] - 1, curr[1])]
      end

      loop do
        curr = @mat[@mat.count]
        break if curr[1] == ss - 1
        @mat[@mat.count + 1] = [curr[0], curr[1] + 1, calculate_sum(curr[0], curr[1] + 1)]
      end

      loop do
        curr = @mat[@mat.count]
        break if curr[0] == ss - 1
        @mat[@mat.count + 1] = [curr[0] + 1, curr[1], calculate_sum(curr[0] + 1, curr[1])]
      end
    end

    def self.calculate_sum(x, y)
      sum = 0
      # TODO
      neighbours = [
        [x, y - 1],
        [x - 1, y],
        [x - 1, y - 1],
        [x + 1, y],
        [x + 1, y - 1],
        [x, y + 1],
        [x + 1, y + 1],
        [x - 1, y + 1]
      ]
      neighbours.each do |neig|
        item = @mat.find { |key, value| value[0] == neig[0] && value[1] == neig[1] }
        if item
          sum += item.last[2]
        end
      end
      if sum > 277678
        puts sum
        return
      end
      sum
    end
  end
end
