module Day3
  class Part1
    @mat = {}
    @board_size = 0
    @destination

    def self.run(destination)
      @mat = {}
      @board_size = 0
      @destination = destination
      calculate_board_size
      return 0 if @board_size == 1
      @mat[(@board_size - 2) * (@board_size - 2)] = [@board_size - 2 - 1, @board_size - 2 - 1]
      fill_mat_for_layer(@board_size - 2)
      (center.first - @mat[destination].first).abs + (center.last - @mat[destination].last).abs
    end

    def self.center
      [(@board_size / 2).floor, (@board_size / 2).floor]
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
        curr = @mat[ss * ss + @mat.count - 1]
        break if curr[0] == ss + 2 - 1
        @mat[ss * ss + @mat.count] = [curr[0] + 1, curr[1]]
      end

      loop do
        curr = @mat[ss * ss + @mat.count - 1]
        break if curr[1] == 0
        @mat[ss * ss + @mat.count] = [curr[0], curr[1] - 1]
      end

      loop do
        curr = @mat[ss * ss + @mat.count - 1]
        break if curr[0] == 0
        @mat[ss * ss + @mat.count] = [curr[0] - 1, curr[1]]
      end

      loop do
        curr = @mat[ss * ss + @mat.count - 1]
        break if curr[1] == ss + 2 - 1
        @mat[ss * ss + @mat.count] = [curr[0], curr[1] + 1]
      end

      loop do
        curr = @mat[ss * ss + @mat.count - 1]
        break if curr[0] == ss + 2 - 1
        @mat[ss * ss + @mat.count] = [curr[0] + 1, curr[1]]
      end
    end
  end
end
